# README

This folder has all the R scripts uploaded. 

- **app**: This script writes the R Shiny App which is currently deployed to [here](https://y-yin.shinyapps.io/Class9a/)

- **mc_sim_pi**: This script writes a small toy simulation of Pi.

- **market_cap_ret_paths_bm**: This scripts writes GIF for Brownian Motion and 8 Large Cap stocks return paths.

- **mc_sim_random_walk**: This scripts simulates random walk in time-series path. 

For detailed simulation steps, please refer to the following.

- Download a stock price and use this as ground truth, say Apple
- Start a MC simulation with a number of generations (such that it equally divides total length of the above stock data, ex. say a stock has 1000 days and define each gen to have 100 days, then there are 10 generations)

  initialize with the 1st generation the following:
  - draw m iid data from N(mu, sigma) each with length n (this can be considered n days)

  starting from 2nd generation, for each generation following:
  - compute mean square error (MSE) between each of m data path with ground truth (the corresponding n days)
  - pick the path with the least MSE and compute mean and variance (=sigma^2) for this path
  - update mu and sigma using the path with least MSE
  - go back up to draw m from N(mu, sigma) move to the next n days
  - Visualize 2 plots:
    - plot ground truth (this is the real stock price) up to current generation
    - plot simulated path (this means every n days is a generation updated) up to current generation

After this is done, the visualization looks like below. 

Critic what's wrong with this or how can this be improved.

- **type-m-type-s**: This scripts simulates Professor Gelman's article [here](https://statmodeling.stat.columbia.edu/2014/11/17/power-06-looks-like-get-used/) and code is provided by another blog [here](https://alexanderetz.com/2015/05/21/type-s-and-type-m-errors/). I simply put the codes together in GIF. 
