
# touchdowns
# field goals
# safety
# turnovers
# end of period

HEADER = 'team,season,points,yards,touchdown,field_goal,missed_fg,punt,turnovers,safety,total,end_of_period,blocked_punt,downs,blocked_fg,playoff\n'

TEAMS_IDS = {
    'Arizona Cardinals': 'ARI',
    'Atlanta Falcons': 'ATL',
    'Baltimore Ravens': 'BAL',
    'Buffalo Bills': 'BUF',

    'Carolina Panthers': 'CAR',
    'Chicago Bears': 'CHI',
    'Cincinnati Bengals': 'CIN',
    'Cleveland Browns': 'CLE',

    'Dallas Cowboys': 'DAL',
    'Denver Broncos': 'DEN',
    'Detroit Lions': 'DET',
    'Green Bay Packers': 'GB',

    'Houston Texans': 'HOU',
    'Indianapolis Colts': 'IND',
    'Jacksonville Jaguars': 'JAX',
    'Kansas City Chiefs': 'KC',

    'Las Vegas Raiders': 'LV',
    'Oakland Raiders': 'LV',
    'Los Angeles Chargers': 'LAC',
    'San Diego Chargers': 'LAC',
    'Los Angeles Rams': 'LAR',
    'St. Louis Rams': 'LAR',
    'Miami Dolphins': 'MIA',

    'Minnesota Vikings': 'MIN',
    'New England Patriots': 'NE',
    'New Orleans Saints': 'NO',
    'New York Giants': 'NYG',

    'New York Jets': 'NYJ',
    'Philadelphia Eagles': 'PHI',
    'Pittsburgh Steelers': 'PIT',
    'San Francisco 49ers': 'SF',

    'Seattle Seahawks': 'SEA',
    'Tampa Bay Buccaneers': 'TB',
    'Tennessee Titans': 'TEN',
    'Washington Commanders': 'WAS',
    'Washington Football Team': 'WAS',
    'Washington Redskins': 'WAS',
}

DATA_SHAPE = {
    'points': 0,
    'yards': 0,
    'touchdown': 0,
    'field_goal': 0,
    'missed_fg': 0,
    'punt': 0,
    'turnovers': 0,
    'safety': 0,
    'total': 0,
    'end_of_period': 0,
    'blocked_punt': 0,
    'downs': 0,
    'blocked_fg': 0,
    'playoff': 0
}

PLAYOFFS = (
    ('LV', 'TEN', 'PIT', 'NYJ', 'IND', 'CLE' , 'PHI', 'TB', 'GB', 'SF', 'NYG', 'ATL'), #2002
    ('NE', 'KC', 'IND', 'BAL', 'TEN', 'DEN' , 'PHI', 'LAR', 'CAR', 'GB', 'SEA', 'DAL'), #2003
    ('PIT', 'NE', 'IND', 'LAC', 'NYJ', 'DEN' , 'PHI', 'ATL', 'GB', 'SEA', 'LAR', 'MIN'), #2004
    ('IND', 'DEN', 'CIN', 'NE', 'JAX', 'PIT' , 'SEA', 'CHI', 'TB', 'NYJ', 'CAR', 'WAS'), #2005
    ('LAC', 'BAL', 'IND', 'NE', 'NYJ', 'KC' , 'CHI', 'NO', 'PHI', 'SEA', 'DAL', 'NYG'), #2006
    ('NE', 'IND', 'LAC', 'PIT', 'JAX', 'TEN' , 'DAL', 'GB', 'SEA', 'TB', 'NYG', 'WAS'), #2007
    ('TEN', 'PIT', 'MIA', 'LAC', 'IND', 'BAL' , 'NYG', 'CAR', 'MIN', 'ARI', 'ATL', 'PHI'), #2008
    ('IND', 'LAC', 'NE', 'CIN', 'NYJ', 'BAL' , 'NO', 'MIN', 'DAL', 'ARI', 'GB', 'PHI'), #2009
    ('NE', 'PIT', 'IND', 'KC', 'BAL', 'NYJ' , 'ATL', 'CHI', 'PHI', 'SEA', 'NO', 'GB'), #2010
    ('NE', 'BAL', 'HOU', 'DEN', 'PIT', 'CIN' , 'GB', 'SF', 'NO', 'NYG', 'ATL', 'DET'), #2011
    ('DEN', 'NE', 'HOU', 'BAL', 'IND', 'CIN' , 'ATL', 'SF', 'GB', 'WAS', 'SEA', 'MIN'), #2012
    ('DEN', 'NE', 'CIN', 'IND', 'KC', 'LAC' , 'SEA', 'CAR', 'PHI', 'GB', 'SF', 'NO'), #2013
    ('NE', 'DEN', 'PIT', 'IND', 'CIN', 'BAL' , 'SEA', 'GB', 'DAL', 'CAR', 'ARI', 'DET'), #2014
    ('DEN', 'NE', 'CIN', 'HOU', 'KC', 'PIT' , 'CAR', 'ARI', 'MIN', 'WAS', 'GB', 'SEA'), #2015
    ('NE', 'KC', 'PIT', 'HOU', 'LV', 'MIA' , 'DAL', 'ATL', 'SEA', 'GB', 'NYG', 'DET'), #2016
    ('NE', 'PIT', 'JAX', 'KC', 'TEN', 'BUF' , 'PHI', 'MIN', 'LAR', 'NO', 'CAR', 'ATL'), #2017
    ('KC', 'NE', 'HOU', 'BAL', 'LAC', 'IND' , 'NO', 'LAR', 'CHI', 'DAL', 'SEA', 'PHI'), #2018
    ('BAL', 'KC', 'NE', 'HOU', 'BUF', 'TEN' , 'SF', 'GB', 'NO', 'PHI', 'SEA', 'MIN'), #2019
    ('KC', 'BUF', 'PIT', 'TEN', 'BAL', 'CLE', 'IND' , 'GB', 'NO', 'SEA', 'WAS', 'TB', 'LAR', 'CHI'), #2020
    ('TEN', 'KC', 'BUF', 'CIN', 'LV', 'NE', 'PIT' , 'GB', 'TB', 'DAL', 'LAR', 'ARI', 'SF', 'PHI'), #2021
    ('KC', 'BUF', 'CIN', 'JAX', 'LAC', 'BAL', 'MIA' , 'PHI', 'SF', 'MIN', 'TB', 'DAL', 'NYG', 'SEA'), #2022
    ('BAL', 'BUF', 'KC', 'HOU', 'CLE', 'MIA', 'PIT' , 'SF', 'DAL', 'DET', 'TB', 'PHI', 'LAR', 'GB'), #2023
)
