script_name <- "GA4_Data.R"

#install.packages('googleAnalyticsR')
#install.packages('openxlsx')


suppressPackageStartupMessages(library(googleAnalyticsR))
suppressPackageStartupMessages(library(googleAuthR))
suppressPackageStartupMessages(library(openxlsx))
suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(readr))

ga_auth(email = email)

for (property_id in property){
  
  #Overview Tab
  
 account_data <- ga_account_list(type = 'ga4')
 account_name <- account_data$account_name[account_data$propertyId == property_id]
 account_id <- account_data$accountId[account_data$propertyId == property_id]
 property_name <- account_data$property_name[account_data$propertyId == property_id]
 overview_table <- data.frame(Parameter = c('Account Name','Account ID', 'Property Name','Property_id','Start Date', 'End Date'),
                               Value = c(account_name,account_id, property_name, property_id, start_date, end_date))
 
  Acquisitions <- ga_data(property_id, 
                          metrics = c('totalUsers',
                                      'newUsers',
                                      'sessions',
                                      'averageSessionDuration',
                                      'screenPageViews',
                                      'screenPageViewsPerSession',
                                      'engagementRate',
                                      'eventCount',
                                      'conversions',
                                      'userConversionRate'),
                          dimensions = c('date', 
                                         'firstUserDefaultChannelGroup',
                                         'firstUserMedium',
                                         'firstUserSource',
                                         'firstUserCampaignName'),
                          date_range = c(start_date, end_date),
                          limit = -1
  )
  Device_category <- ga_data(property_id, 
                             metrics = c('totalUsers',
                                         'newUsers',
                                         'sessions',
                                         'averageSessionDuration',
                                         'screenPageViews',
                                         'screenPageViewsPerSession',
                                         'engagementRate',
                                         'eventCount',
                                         'conversions',
                                         'userConversionRate'),
                             dimensions = c('date', 
                                            'firstUserDefaultChannelGroup',
                                            'firstUserMedium',
                                            'firstUserSource',
                                            'firstUserCampaignName',
                                            'deviceCategory'),
                             date_range = c(start_date, end_date),
                             limit = -1
  )                   
  Geography <- ga_data(property_id, 
                       metrics = c('totalUsers',
                                   'newUsers',
                                   'sessions',
                                   'averageSessionDuration',
                                   'screenPageViews',
                                   'screenPageViewsPerSession',
                                   'engagementRate',
                                   'eventCount',
                                   'conversions',
                                   'userConversionRate'),
                       dimensions = c('date', 
                                      'country',
                                      'region',
                                      'firstUserDefaultChannelGroup',
                                      'firstUserMedium',
                                      'firstUserSource',
                                      'firstUserCampaignName'),
                       date_range = c(start_date, end_date),
                       limit = -1
  )                    
  Landing_Page <- ga_data(property_id, 
                          metrics = c('totalUsers',
                                      'newUsers',
                                      'sessions',
                                      'averageSessionDuration',
                                      'screenPageViews',
                                      'screenPageViewsPerSession',
                                      'engagementRate',
                                      'eventCount',
                                      'conversions',
                                      'userConversionRate'),
                          dimensions = c('date', 
                                         'landingPagePlusQueryString',
                                         'firstUserDefaultChannelGroup',
                                         'firstUserMedium',
                                         'firstUserSource',
                                         'firstUserCampaignName'),
                          date_range = c(start_date, end_date),
                          limit = -1
  ) 
  Content <- ga_data(property_id, 
                     metrics = c('totalUsers',
                                 'newUsers',
                                 'sessions',
                                 'averageSessionDuration',
                                 'screenPageViews',
                                 'screenPageViewsPerSession',
                                 'engagementRate',
                                 'eventCount',
                                 'conversions',
                                 'userConversionRate'),
                     dimensions = c('date', 
                                    'pagePath',
                                    'firstUserDefaultChannelGroup',
                                    'firstUserMedium',
                                    'firstUserSource',
                                    'firstUserCampaignName'),
                     date_range = c(start_date, end_date),
                     limit = -1
  )
  
  Events <- ga_data(property_id, 
                    metrics = c('totalUsers',
                                'newUsers',
                                'sessions',
                                'averageSessionDuration',
                                'screenPageViews',
                                'screenPageViewsPerSession',
                                'engagementRate',
                                'eventCount',
                                'conversions',
                                'userConversionRate'),
                    dimensions = c('date', 
                                   'eventName',
                                   'isConversionEvent',
                                   'firstUserDefaultChannelGroup',
                                   'firstUserMedium',
                                   'firstUserSource',
                                   'firstUserCampaignName'),
                    date_range = c(start_date, end_date),
                    limit = -1
  )
  # Define the path to folder
  setwd(paste0(path,property_id))
  
  #Define the filename
  File_xlsx <- paste0("GA4Data_",property_id, ".xlsx")
  
  # Write to an Excel file
  tryCatch ({
    excel_tabs_Audience<- list('Overview Tab'    = overview_table,
                               'Acquisitions'    = Acquisitions,
                               'Device category' = Device_category,
                               'Geography'       = Geography,
                               'Landing Page'    = Landing_Page, 
                               'Content'         = Content,
                               'Events'          = Events)
    write.xlsx(excel_tabs_Audience, file = File_xlsx)
    message(paste("Successfully wrote to", File_xlsx))
  },
  error = function(e){
    message(paste("Failed to write to", File_xlsx))
    message("Error message")
    print(e)}
  )
# Write to separate csv 
  
  tryCatch({
    sheets <- excel_sheets(File_xlsx)
    filename <- paste0(property_id,"_", sheets, ".csv")
    
    dats <- lapply(sheets, read_excel, path = File_xlsx)
    lapply(seq_along(dats),
           function(i)
             write_csv(dats[[i]],filename[[i]])
    )
    message(cat("Successfully wrote to ", filename, sep = "\n"))
  },
  error = function(e){
    message(cat("Failed to write to", filename, sep = "\n "))
    message("Error message")
    print(e)}
  )
}
