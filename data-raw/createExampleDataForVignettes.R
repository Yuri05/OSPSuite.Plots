library(data.table)

# Time profile -------

exampleDataTimeProfile <- data.table()


##  set 1 and 2 ----------------
# Simulation time
simTime <- seq(0, 24, 0.1)


# Simulated data 1: exponential decay
data <- data.table(
  SetID = "DataSet1",
  Type = "simulated",
  time = simTime,
  values = 15 * exp(-0.1 * simTime),
  dimension = "concentration",
  minValues = 12 * exp(-0.12 * simTime),
  maxValues = 18 * exp(-0.08 * simTime),
  caption = "Simulated Data 1"
)

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)

# Simulated data 2: first order absorption with exponential decay
data <- data.frame(
  SetID = "DataSet2",
  Type = "simulated",
  time = simTime,
  values = 10 * exp(-0.1 * simTime) * (1 - exp(-simTime)),
  dimension = "concentration",
  minValues = 8 * exp(-0.12 * simTime) * (1 - exp(-simTime)),
  maxValues = 12 * exp(-0.08 * simTime) * (1 - exp(-simTime)),
  caption = "Simulated Data 2"
)

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)



## observed datat set 1 and 2

# Observed data 1
data <- data.frame(
  SetID = "DataSet1",
  Type = "observed",
  time = c(1, 3, 6, 12, 24),
  values = c(11.7, 8.4, 7.5, 3.6, 1.0),
  dimension = "concentration",
  minValues = c(11, 8, 7.1, 3.2, 0.8),
  maxValues = c(12.1, 9, 7.8, 3.9, 1.2),
  sd = c(0.204, 0.21, 0.241, 0, 0.18),
  caption = "Observed Data 1"
)

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)


# Observed data 2
data <- data.frame(
  SetID = "DataSet2",
  Type = "observed",
  time = c(0, 1, 3, 6, 12, 24),
  values = c(0, 6.1, 7.3, 4.4, 3.2, 1.1),
  dimension = "concentration",
  minValues = c(0, 5.7, 7.0, 4.3, 2.5, 0.8),
  maxValues = c(0, 7.1, 8.2, 5.8, 3.3, 1.11),
  caption = "Observed Data 2"
)

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)

##  set 3 -------------------------

set.seed(22)

obsData <- data.frame(
  time = rep(1:7, 2),
  values = c(10 * exp(-1:-7), 10 * exp(-1:-7)),
  dimension = "concentration",
  error_relativ = exp(abs(rnorm(14, 0, 0.1))),
  caption = c(rep("group A", 7), rep("group B", 7)),
  lloq = c(rep(0.05, 14))
)

data <- rbind(
  copy(obsData) %>%
    dplyr::mutate(values = values * rnorm(14, 1, .25)) %>%
    dplyr::mutate(values = ifelse(values <= lloq, lloq / 2, values)),
  copy(obsData) %>%
    dplyr::group_by(caption) %>%
    dplyr::mutate(values = values * rnorm(7, 1, .05)) %>%
    dplyr::mutate(values = cumsum(values) / sum(values)) %>%
    dplyr::mutate(lloq = rep(NA, 7)) %>%
    dplyr::mutate(dimension = "fraction")
) %>%
  dplyr::mutate(SetID = "DataSet3") %>%
  dplyr::mutate(Type = "observed")

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)


simTime <- seq(1, 10, 0.1)
simData <- data.frame(
  time = simTime,
  values = 10 * exp(-simTime),
  caption = "simulated",
  dimension = "concentration",
  minValues = 8 * exp(-simTime),
  maxValues = 12 * exp(-simTime)
)

data <- rbind(
  simData,
  copy(simData) %>%
    dplyr::mutate(values = cumsum(values) / sum(values)) %>%
    dplyr::mutate(minValues = 0.8 * values) %>%
    dplyr::mutate(maxValues = ifelse(1.2 * values > 1,
      1,
      1.2 * values
    )) %>%
    dplyr::mutate(dimension = "fraction")
) %>%
  dplyr::mutate(SetID = "DataSet3") %>%
  dplyr::mutate(Type = "simulated")


exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)


##  set 4 -------------------------

# Observed data 2
data <- data.table()

for (i in seq(1, 10)) {
  data <- rbind(
    data,
    data.table(
      SetID = "DataSet4",
      Type = "observed",
      time = 1:7,
      values = 10 * exp(-1:-7) + rnorm(7, 0, .25),
      error = abs(rnorm(7, 0, 0.1)),
      caption = rep(paste0("ID", i), 7),
      gender = ifelse(i < 6, "female", "male")
    )
  )
}

exampleDataTimeProfile <- rbind(exampleDataTimeProfile,
  data,
  fill = TRUE
)

# metaData

metaData <- list(
  time = list(
    dimension = "Time",
    unit = "h"
  ),
  values = list(
    dimension = "Concentration",
    unit = "mg/l"
  )
)


setattr(exampleDataTimeProfile, "metaData", metaData)



# save data

exampleDataTimeProfile <- setDF(exampleDataTimeProfile)
usethis::use_data(exampleDataTimeProfile, overwrite = TRUE, internal = FALSE)


# Covariates -------

## Set 1  ---

exampleDataCovariates <- fread(file.path("data-raw", "test-data.csv")) %>%
  dplyr::mutate(SetID = "DataSet1")


## Set 2  ---

set.seed(1)
data <- data.table(SetID = 'DataSet2',
  AgeBin = c(rep("adult", 200), rep("pediatric",150)),
  Sex = rep(c("Female","Male"), 175),
  Obs  = c(rnorm(200, 20, 5), rnorm(150,25,10))+
    rep(c(10,50), 175))
data[,ID:=.I]

exampleDataCovariates <- rbind(exampleDataCovariates,
                                data,
                                fill = TRUE
)


# metaData will be used during the smart mapping
# to label the axes as "dimension [unit]"
metaData <- list(
  Age = list(
    dimension = "Age in years",
    unit = "year(s)"
  ),
  Ratio = list(
    dimension = "Fraction",
    unit = ""
  ),
  Obs = list(
    dimension = "Concentration",
    unit = "µg/ml"
  ),
  Pred = list(
    dimension = "Concentration",
    unit = "µg/ml"
  ),
  SD = list(
    dimension = "Concentration",
    unit = "µg/ml"
  )
)


setattr(exampleDataCovariates, "metaData", metaData)

# save data
setcolorder(exampleDataCovariates, "SetID")

usethis::use_data(exampleDataCovariates, overwrite = TRUE, internal = FALSE)
