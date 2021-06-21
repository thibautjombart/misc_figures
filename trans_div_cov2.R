
# Produce back-of-the-enveloppe estimate of the distribution of the transmission
# divergence for SARS-CoV2

# Parameters

## source:
genome_length <- 29903

## source: https://www.eurosurveillance.org/content/10.2807/1560-7917.ES.2020.25.17.2000257
gen_time_mean <- 5.2
gen_time_sd <- 1.7
gen_time_params <- epitrix::gamma_mucv2shapescale(gen_time_mean,
                                                  gen_time_sd / gen_time_mean)
gen_time_dist <- distcrete::distcrete("gamma",
                                      shape = gen_time_params$shape,
                                      scale = gen_time_params$scale,
                                      w = 0.5, interval = 1)


## source: https://www.pnas.org/content/117/38/23652
mu <- 1e-3 # / year / site

## mutations per day
mu_day <- (mu / 365) * genome_length

## average divergence
mu_day * 5.2


## Simulate transmission divergence (100,000 transmissions)
sim_div <- function(n) {
  rpois(n,
        lambda = gen_time_dist$r(n) * mu_day)
}


res <- sim_div(1e5)


# Make plot
library(tidyverse)


res_df <- res %>%
  table() %>%
  data.frame() %>%
  setNames(c("Mutations", "n")) %>%
  mutate(Frequency = n / sum(n))

fig <- res_df %>%
  ggplot(aes(x = Mutations, y = Frequency)) +
  geom_col() +
  theme_bw() +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Transmission divergence for COVID-19",
       subtitle = "Based on 100,000 simulations",
       x = "Mutations between primary and secondary case")
fig


ggsave(fig, filename = "trans_div_covid19.png")
