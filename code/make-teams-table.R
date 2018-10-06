---
  # ===================================================================
# Title: workout1
# Description: It is a data preparing R script
# Input(s): data file 'nba2018.csv' about players
# Output(s): 'nba2018-teams.csv'
# Author(s): Jiahe Fan
# Date: 10-03-2018
# ===================================================================
---
  
# Data Preparation

library(readr)
library(dplyr)
library(ggplot2)
dat <- read_csv('../data/nba2018.csv')

read_csv("../data/nba2018.csv", col_types = cols(
  player = col_character(),
  number = col_character(),
  position = col_character(),
  height = col_character(),
  birth_date = col_character(),
  country = col_character(),
  experience = col_character(),
  college = col_character()
))

read_csv("../data/nba2018.csv", col_types = cols(
  salary = col_double(),
  field_goal_perc = col_double(),
  points3_perc = col_double(),
  points2_perc = col_double(),
  effective_field_goal_perc = col_double(),
  points1_perc = col_double()
))



#A bit of processing

dat$experience[dat$experience=="R"] <- 0
dat$experience <- as.integer(dat$experience)

dat$salary <- dat$salary/1000000

dat$position[dat$position == 'C'] = 'center'
dat$position[dat$position == 'PF'] = 'power_fwd'
dat$position[dat$position == 'PG'] = 'point_guard'
dat$position[dat$position == 'SF'] = 'small_fwd'
dat$position[dat$position == 'SG'] = 'shoot_guard'



#Adding new variables

dat <- mutate(dat,
              missed_fg = (field_goals_atts-field_goals),
              missed_ft = (points1_atts-points1),
              rebounds = (off_rebounds+def_rebounds),
              efficiency = ((points + rebounds +assists + steals + blocks
                             - missed_fg - missed_ft - turnovers) / games))
summary(dat$efficiency)

sink("../output/efficiency-summary.txt")



#Creating nba2018-teams.csv

team <- summarise(
  group_by(dat, team),
  experience = round(sum(experience), 2),
  salary = round(sum(salary), 2),
  points3 = sum(points3),
  points2 = sum(points2),
  points1 = sum(points1),
  points = sum(points),
  off_rebounds = sum(off_rebounds),
  def_rebounds = sum(def_rebounds),
  assists = sum(assists),
  steals = sum(steals),
  blocks = sum(blocks),
  fouls = sum(fouls),
  turnovers = sum(turnovers),
  efficiency = sum(efficiency)
)

sink("../data/teams-summary.txt")
write_csv(team, "../data/nba2018-teams.csv")