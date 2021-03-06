context("pfa.glm")

test_that("check binomial family GLMs", {
  
  # checking the following link functions for binomial family
  # logit, probit, cauchit, log, cloglog
  
  input <- list(X1=3, X2=3)
  
  X1 <- rnorm(100)
  X2 <- runif(100)
  Y <- 3 - 4 * X1 + 3 * X2 + rnorm(100, 0, 4)
  Y <- Y > 0
  
  logit_model <- glm(Y ~ X1 + X2, family = binomial(logit))
  
  logit_model_as_pfa <- pfa(logit_model)
  logit_engine <- pfa.engine(logit_model_as_pfa)
  
  expect_equal(logit_engine$action(input), 
               unname(predict(logit_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  probit_model <- glm(Y ~ X1 + X2, family = binomial(probit))
  
  probit_model_as_pfa <- pfa(probit_model)
  probit_engine <- pfa.engine(probit_model_as_pfa)
  
  expect_equal(probit_engine$action(input), 
               unname(predict(probit_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  cauchit_model <- glm(Y ~ X1 + X2, family = binomial(cauchit))
  
  cauchit_model_as_pfa <- pfa(cauchit_model)
  cauchit_engine <- pfa.engine(cauchit_model_as_pfa)
  
  expect_equal(cauchit_engine$action(input), 
               unname(predict(cauchit_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  cloglog_model <- glm(Y ~ X1 + X2, family = binomial(cloglog))
  
  cloglog_model_as_pfa <- pfa(cloglog_model)
  cloglog_engine <- pfa.engine(cloglog_model_as_pfa)
  
  expect_equal(cloglog_engine$action(input), 
               unname(predict(cloglog_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  set.seed(1)
  n <- 100
  N <- 1 + rpois(n,5)
  X1 <- runif(n)
  X2 <- rexp(n)
  s <- X2 - X1 - 2
  p <- exp(s)/(1+exp(s))
  Y <- integer(0)
  for(i in 1:n){
    new_Y <-  rbinom(1,prob=p[i],size=N[i])
    Y <- c(Y,new_Y)
  }
  
  suppressWarnings(log_model <- glm(cbind(Y, N-Y) ~ X1 + X2, family=binomial(log), 
                                    start = c(log(sum(Y) / sum(N)), -rep(1e-4, 2)),
                                    maxit = 500))
  
  log_model_as_pfa <- pfa(log_model)
  log_engine <- pfa.engine(log_model_as_pfa)
  
  expect_equal(log_engine$action(input), 
               unname(predict(log_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
})

test_that("check gaussian family GLMs", {
  
  # checking the following link functions for gaussian family
  # identity, log and inverse
  
  input <- list(X1=3, X2=3)
  
  X1 <- runif(100)
  X2 <- runif(100)
  Y <- pmax(1, 25 + 4 * X1 + 3 * X2 + rnorm(100))
  
  gauss_model <- glm(Y ~ X1 + X2, family=gaussian())
  
  gauss_model_as_pfa <- pfa(gauss_model)
  gauss_engine <- pfa.engine(gauss_model_as_pfa)
  
  expect_equal(gauss_engine$action(input), 
               unname(predict(gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  log_gauss_model <- glm(Y ~ X1 + X2, family=gaussian(log))
  
  log_gauss_model_as_pfa <- pfa(log_gauss_model)
  log_gauss_engine <- pfa.engine(log_gauss_model_as_pfa)
  
  expect_equal(log_gauss_engine$action(input), 
               unname(predict(log_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  inv_gauss_model <- glm(Y ~ X1 + X2, family=gaussian(inverse))
  
  inv_gauss_model_as_pfa <- pfa(inv_gauss_model)
  inv_gauss_engine <- pfa.engine(inv_gauss_model_as_pfa)
  
  expect_equal(inv_gauss_engine$action(input), 
               unname(predict(inv_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
})

test_that("check Gamma family GLMs", {
  
  # checking the following link functions for Gamma family
  # inverse, identity and log
  
  input <- list(X = 0.5)
  
  X <- runif(100)
  Y <- rgamma(100, 10, .1)

  gamma_model <- glm(Y ~ X, family=Gamma())
  
  gamma_model_as_pfa <- pfa(gamma_model)
  gamma_engine <- pfa.engine(gamma_model_as_pfa)
  
  expect_equal(gamma_engine$action(input), 
               unname(predict(gamma_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)

  ident_gamma_model <- glm(Y ~ X, family=Gamma(identity))
  
  ident_gamma_model_as_pfa <- pfa(ident_gamma_model)
  ident_gamma_engine <- pfa.engine(ident_gamma_model_as_pfa)
  
  expect_equal(ident_gamma_engine$action(input), 
               unname(predict(ident_gamma_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
    
  log_gamma_model <- glm(Y ~ X, family=Gamma(log))
  
  log_gamma_model_as_pfa <- pfa(log_gamma_model)
  log_gamma_engine <- pfa.engine(log_gamma_model_as_pfa)
  
  expect_equal(log_gamma_engine$action(input), 
               unname(predict(log_gamma_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
})
  
test_that("check inverse gaussian family GLMs", {  
  
  # checking the following link functions for inverse.gaussian family
  # 1/mu^2, inverse, identity and log
  
  input <- list(X1 = .5, X2 = .5, X3 = .5)
  
  n <- 100
  X1 <- runif(n, 0, 1)
  X2 <- runif(n, 0, 1)
  X3 <- runif(n, 0, 1)
  f0 <- function(x) 2 * sin(pi * x)
  f1 <- function(x) exp(2 * x)
  f2 <- function(x) 0.2 * x^11 * (10 * (1 - x))^6 + 10 * (10 * x)^3 * (1 - x)^10
  f <- f0(X1) + f1(X2) + f2(X3)
  e <- rnorm(n, 0, .1)
  Y <- 10 + f + e
  
  inv_gauss_model <- glm(Y ~ X1 + X2 + X3, family=inverse.gaussian())
  
  model_as_pfa <- pfa(inv_gauss_model)
  inv_gauss_engine <- pfa.engine(model_as_pfa)
  
  expect_equal(inv_gauss_engine$action(input), 
               unname(predict(inv_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  inv_inv_gauss_model <- glm(Y ~ X1 + X2 + X3, family=inverse.gaussian(inverse))
  
  inv_inv_gauss_model_as_pfa <- pfa(inv_inv_gauss_model)
  inv_inv_gauss_engine <- pfa.engine(inv_inv_gauss_model_as_pfa)
  
  expect_equal(inv_inv_gauss_engine$action(input), 
               unname(predict(inv_inv_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  
  ident_inv_gauss_model <- glm(Y ~ X1 + X2 + X3, family=inverse.gaussian(identity))
  
  ident_inv_gauss_model_as_pfa <- pfa(ident_inv_gauss_model)
  ident_inv_gauss_engine <- pfa.engine(ident_inv_gauss_model_as_pfa)
  
  expect_equal(ident_inv_gauss_engine$action(input), 
               unname(predict(ident_inv_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  log_inv_gauss_model <- glm(Y ~ X1 + X2 + X3, family=inverse.gaussian(log))
  
  log_inv_gauss_model_as_pfa <- pfa(log_inv_gauss_model)
  log_inv_gauss_engine <- pfa.engine(log_inv_gauss_model_as_pfa)
  
  expect_equal(log_inv_gauss_engine$action(input), 
               unname(predict(log_inv_gauss_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
})
  
test_that("check poisson family GLMs", {
  
  # checking the following link functions for poisson family
  # log, identity, and sqrt
  
  input <- list(X1=3, X2=3)
  
  X1 <- runif(100)
  X2 <- runif(100)
  Y <- round(3 + 5 * X1 + 3 * X2 + rnorm(100, 0, 1))

  poisson_model <- glm(Y ~ X1 + X2, family=poisson())
  
  poisson_model_as_pfa <- pfa(poisson_model)
  poisson_engine <- pfa.engine(poisson_model_as_pfa)
  
  expect_equal(poisson_engine$action(input), 
               unname(predict(poisson_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)  
    
  ident_poisson_model <- glm(Y ~ X1 + X2, family=poisson(identity))
  
  ident_poisson_model_as_pfa <- pfa(ident_poisson_model)
  ident_poisson_engine <- pfa.engine(ident_poisson_model_as_pfa)
  
  expect_equal(ident_poisson_engine$action(input), 
               unname(predict(ident_poisson_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
  sqrt_poisson_model <- glm(Y ~ X1 + X2, family=poisson(sqrt))
  
  sqrt_poisson_model_as_pfa <- pfa(sqrt_poisson_model)
  sqrt_poisson_engine <- pfa.engine(sqrt_poisson_model_as_pfa)
  
  expect_equal(sqrt_poisson_engine$action(input), 
               unname(predict(sqrt_poisson_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)

})
  
test_that("check no intercept GLMs", {
  
  input <- list(X1=3, X2=3)
  
  X1 <- runif(100)
  X2 <- runif(100)
  Y <- 25 + 4 * X1 + 3 * X2 + rnorm(100)

  no_int_model <- glm(Y ~ X1 + X2 - 1, family=gaussian())
  
  no_int_model_as_pfa <- pfa(no_int_model)
  no_int_engine <- pfa.engine(no_int_model_as_pfa)
  
  expect_equal(no_int_engine$action(input), 
               unname(predict(no_int_model, newdata = as.data.frame(input), type='response')),
               tolerance = .0001)
  
})
