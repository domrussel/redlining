# A script to geocode branch data
# 7/24/2019

### Load in the branch data, publicly available at: https://research.fdic.gov/bankfind/ ###
branch_dat <- read.csv("data/wells_branches.csv", stringsAsFactors = FALSE)

# Must get google API key in advance
register_google(key = googlekey)

### 1) Geocode DC area branch data ###
dc_area_states <- filter(branch_dat, State %in% c("VA", "DC", "MD", "WV"))

# Geocode first address
curr_branch_address <- paste0(dc_area_states[1,]["Address"], ", ",
                              dc_area_states[1,]["City"], ", ",
                              dc_area_states[1,]["State"], " ",
                              dc_area_states[1,]["Zip"])
geocoded_dc_branch_dat <- geocode(curr_branch_address)

# Geocode the rest of the addresses
for(i in 2:nrow(dc_area_states)){
  # Show status
  print(i)
  curr_branch_address <- paste0(dc_area_states[i,]["Address"], ", ",
                                dc_area_states[i,]["City"], ", ",
                                dc_area_states[i,]["State"], " ",
                                dc_area_states[i,]["Zip"])
  curr_branch_geocoded <- geocode(curr_branch_address)
  geocoded_dc_branch_dat <- bind_rows(geocoded_dc_branch_dat, curr_branch_geocoded)
}

# Check match rate
sum(is.na(geocoded_dc_branch_dat$lon)) / nrow(geocoded_dc_branch_dat) # 99.8%

# Write the geocoded dc branch dat
dc_area_states %>% 
  cbind(geocoded_dc_branch_dat) %>% 
  rename(X=lon, Y=lat) %>% 
  filter(!is.na(X)) %>% 
  write_csv("data/dc_area_branch_dat.csv")

### 2) Geocode Memphis area branch data ###
memphis_area_states <- filter(branch_dat, State %in% c("TN", "AR", "MS"))

# Geocode first address
curr_branch_address <- paste0(memphis_area_states[1,]["Address"], ", ",
                              memphis_area_states[1,]["City"], ", ",
                              memphis_area_states[1,]["State"], " ",
                              memphis_area_states[1,]["Zip"])
geocoded_memphis_branch_dat <- geocode(curr_branch_address)

# Geocode the rest of the addresses
for(i in 2:nrow(memphis_area_states)){
  # Show status
  print(i)
  curr_branch_address <- paste0(memphis_area_states[i,]["Address"], ", ",
                                memphis_area_states[i,]["City"], ", ",
                                memphis_area_states[i,]["State"], " ",
                                memphis_area_states[i,]["Zip"])
  curr_branch_geocoded <- geocode(curr_branch_address)
  geocoded_memphis_branch_dat <- bind_rows(geocoded_memphis_branch_dat, curr_branch_geocoded)
}

# Check match rate
sum(is.na(geocoded_memphis_branch_dat$lon)) / nrow(geocoded_memphis_branch_dat) # 100%

# Write the geocoded Memphis branch dat
memphis_area_states %>% 
  cbind(geocoded_memphis_branch_dat) %>% 
  rename(X=lon, Y=lat) %>% 
  write_csv("data/memphis_area_branch_dat.csv")
