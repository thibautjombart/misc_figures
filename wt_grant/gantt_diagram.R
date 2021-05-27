# Read google sheet and create a gannt diagram


## Dependencies
pacman::p_load(googlesheets4)
if (!require(ganttrify)) {
  remotes::install_github("giocomai/ganttrify")
  require(ganttrify)
}

url <- "https://docs.google.com/spreadsheets/d/16ii4TVvzvO4510fIuYay9YM8BYnM7JzpUmH47jthNVc/edit#gid=841130395"
activities <- googlesheets4::read_sheet(act_url, sheet = "activities")
miles <- googlesheets4::read_sheet(url, sheet = "milestones")

my_pal <- c("#e0c559",
            "#e5aa75",
            "#df757e",
            "#93ac93",
            "#ac9393",
            "#87aade")

gantt <- ganttrify(activities,
                   spots = miles,
                   project_start_date = "2021-11",
                   font_family = "Roboto Condensed",
                   month_break = 3,
                   mark_quarters = TRUE,
                   colour_palette = my_pal,
                   alpha_wp = 0.9)
gantt

png("gant_wt.png", width = 1400, height = 800, res = 150)

print(gantt)

dev.off()

