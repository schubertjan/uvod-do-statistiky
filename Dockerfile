# This dockerfile will install Rocker with the standard R developent environment

FROM rocker/rstudio:4.1.2

ARG PKG_NAME
ENV DEBIAN_FRONTEND=noninteractive

# Install some linux dependencies
RUN apt-get update \
    && apt-get install -y \
    zlib1g-dev \
    libxml2-dev \
    git \
    tzdata \
    zip \
    unzip \
    xorg \
    openbox \
    vim \
    # texlive-latex-extra \
    locales 
    # libudunits2-dev \
    # libgdal-dev \
    # libgeos-dev \
    # libproj-dev

# Start installation of package
RUN echo "Install Dependencies for ${PKG_NAME}" \
    && R -e "install.packages(c('png', 'jpeg', 'git2r','devtools', 'zoo', 'lubridate', 'testthat', 'roxygen2', 'bookdown', 'tinytex'))" \ 
    && R -e "install.packages(c('data.table', 'haven', 'corrplot', 'knitr', 'rmarkdown', 'DT', 'lme4', 'rvest', 'httr'))" \
    && R -e "install.packages(c('plotly', 'gifski', 'leaflet', 'animation'))"
    # && R -e "install.packages(c('RCzechia','ggplot2'))"

RUN R -e "tinytex::install_tinytex()"

RUN rstudio-server start