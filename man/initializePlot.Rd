% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_Layer.R
\name{initializePlot}
\alias{initializePlot}
\title{initializePlot}
\usage{
initializePlot(metaData = NULL, mapping = NULL)
}
\arguments{
\item{metaData}{A named list of information about the \code{data} such as the \code{dimension} and \code{unit} of its variables.}

\item{mapping}{Default list of aesthetic mappings to use for plot}
}
\value{
A \code{ggplot} object
}
\description{
Initialize a \code{ggplot} object
with watermark
and set its labels by metaData
}
