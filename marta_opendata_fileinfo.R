library(readr); library(stringr); library(lubridate); library(rvest)
library(dplyr)

# sample_file_page <- "http://opendata.itsmarta.com/hackathon/2016/December/GTFS/"
homepage <- "http://opendata.itsmarta.com/hackathon"

get_file_info <- function(page){
     page_html <- read_html(page)
     fileinfo <- read_file(page)
     
     relative_link <- page_html %>% html_nodes("a") %>% html_attr("href") %>% .[2:length(.)]
     full_link <-  relative_link %>% paste0("http://opendata.itsmarta.com", .)
     directory <- relative_link %>% str_extract(".+/(?=.+\\..+)")
     content_name <- page_html %>% html_nodes("a") %>% .[2:length(.)] %>% html_text()
     
     fileinfo_cleaned <- 
          str_extract_all(fileinfo, pattern = "(?<=(<br>)).{30,40}(?= ?<A)") %>% 
          .[[1]] %>% 
          str_replace_all("<br>", "") %>% 
          str_trim()
     
     # Date Time
     date_time <- 
          fileinfo_cleaned %>% 
          str_extract("\\d{1,2}/\\d{1,2}/\\d{4}\\s+\\d{1,2}:\\d{1,2}\\s{1}[AP]M")
     date_time_formatted <- 
          mdy_hm(date_time, tz = "EST")
     
     # File Size
     filesize <- 
          str_sub(fileinfo_cleaned, nchar(date_time)+1, nchar(fileinfo_cleaned)) %>% 
          str_trim() %>% 
          as.integer()
     
     return(data_frame(content_name, date_time_formatted, filesize, directory, 
                       content_type = "file", full_link))
}

get_dir_info <- function(page){
     page_html <- read_html(page)
     fileinfo <- read_file(page)
     
     relative_link <-  
          page_html %>% html_nodes("a") %>% html_attr("href") %>% .[2:length(.)]
     
     full_link <- 
          relative_link %>%
          paste0("http://opendata.itsmarta.com", .)
     
     content_name <- page_html %>% html_nodes("a") %>% .[2:length(.)] %>% html_text()
     
     dirinfo_cleaned <- 
          str_extract_all(fileinfo, pattern = "(?<=(<br>)).{30,40}(?= ?<A)") %>% 
          .[[1]] %>% 
          str_replace_all("<br> ", "") %>% 
          str_replace_all("&lt;dir&gt;", "") %>%
          str_trim()
     
     # Date Time
     date_time <- 
          dirinfo_cleaned %>% 
          str_extract("\\d{1,2}/\\d{1,2}/\\d{4}\\s+\\d{1,2}:\\d{1,2}\\s{1}[AP]M")
     date_time_formatted <- 
          mdy_hm(date_time, tz = "EST")

     return(data_frame(content_name, filesize = NA, date_time_formatted, directory = relative_link,
                       content_type = "directory", full_link))
}

filelist_or_parentdir <- function(page){
     ifelse(read_file(page) %>% str_detect("&lt;dir&gt;"), "parentdir", "filelist")
}

get_child_info <- function(directory_info){
     children <- vector(mode = "list", length = nrow(directory_info))
     directory_links <- directory_info %>% filter(content_type == "directory")
     if(nrow(directory_links) == 0){
          stop("Contains no directory links")
     }
     for(i in seq_along(directory_links$full_link)){
          if(directory_links$full_link[i] == 
             "http://opendata.itsmarta.com/hackathon/2017/February/Mobility_Data/"){
               children[[i]] <- data_frame(content_name = "Mobility_Data", 
                                           date_time_formatted = NA, filesize = NA, 
                                           directory = directory_links$directory[i], 
                                           content_type = "username_pass", 
                                           full_link = directory_links$full_link[i])
          } else{
               if(filelist_or_parentdir(directory_links$full_link[i]) == "filelist"){
                    children[[i]] <- get_file_info(directory_links$full_link[i])
               } else{
                    children[[i]] <- get_dir_info(directory_links$full_link[i])
               }
          }
     }
     return(bind_rows(children))
}

get_all_links <- function(homepage){
     continue <- TRUE
     i <- 1
     while(continue & i <= 10){
          if(i == 1){
               df <- get_dir_info(homepage)
               df1 <- get_child_info(df)
               df <- bind_rows(df, df1)
          } else{
               df1 <- get_child_info(df1)
               df <- bind_rows(df, df1)
          }
          i <- i + 1
          if(nrow(df1 %>% filter(content_type == "directory")) == 0){
               continue <- FALSE
          }
     }
     
     cat("Number of files by subdirectory:", "\n", "-------------------------------", "\n")
     df %>% filter(content_type != "directory") %>% group_by(directory) %>% 
          summarise(count = n()) %>% arrange(desc(count)) %>% print()
     return(df)
}

all_file_info <- get_all_links(homepage)

all_file_info <- 
     all_file_info %>% mutate(filesize_kb_MB = 
                                   ifelse(filesize < 1048576, 
                                          paste0(round(filesize / 1024, 2), " kb"), 
                                          paste0(round(filesize / 1048576, 2), " MB")))

write_csv(all_file_info, "~/MARTA Open Data File Info.csv", na = "")
