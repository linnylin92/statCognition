context("Test synthetic generator")

## .synthetic_generator_seed is correct

test_that(".synthetic_generator_seed works", {
  set.seed(10)
  dat <- data_object(list(mat = matrix(1:60, 6, 5), pheno = data.frame(age = 1:6)))
  init <- synthetic_initializer()

  res <- .synthetic_generator_seed(dat, init)

  expect_true(class(res) == "data")
  expect_true(all(dim(res$mat) == c(6,5)))
})

test_that(".synthetic_generator_seed is reproducible", {
  set.seed(10)
  dat <- data_object(list(mat = matrix(1:60, 6, 5), pheno = data.frame(age = 1:6)))
  init <- synthetic_initializer()

  res <- .synthetic_generator_seed(dat, init, seed = 5)
  res2 <- .synthetic_generator_seed(dat, init, seed = 5)

  expect_true(all(res$mat == res2$mat))
})

test_that(".synthetic_generator_seed matches synthetic_generator", {
  set.seed(10)
  dat <- statCognition::dat
  syn_init <- statCognition:::synthetic_initializer(lambda = 4)
  set.seed(9)
  res <- statCognition:::synthetic_generator(dat, syn_init)

  seed <- get_seed(res)
  res2 <- .synthetic_generator_seed(dat, syn_init, seed = seed)

  expect_true(all(res$mat == res2$mat))
})

##################

## synthetic_generator is correct

test_that("synthetic_generator works", {
  set.seed(10)
  dat <- data_object(list(mat = matrix(1:60, 6, 5), pheno = data.frame(age = 1:6)))
  init <- synthetic_initializer()

  res <- synthetic_generator(dat, init)

  expect_true(class(res) == "data")
  expect_true(all(dim(res$mat) == c(6,5)))
  expect_true("synthetic_seed" %in% names(res))
})

test_that("synthetic_generator respects changes to lambda", {
  set.seed(10)
  dat <- data_object(list(mat = matrix(1:60, 6, 5), pheno = data.frame(age = 1:6)))
  init <- synthetic_initializer(lambda = 20)
  init_alt <- synthetic_initializer()

  set.seed(10)
  res <- synthetic_generator(dat, init)
  res2 <- .synthetic_generator_seed(dat, init, get_seed(res))
  res3 <- .synthetic_generator_seed(dat, init_alt, get_seed(res))

  expect_true(all(res$mat == res2$mat))
  expect_true(!any(res$mat == res3$mat))
})

##################

## get_seed is correct

test_that("get_seed works", {
  set.seed(10)
  dat <- data_object(list(mat = matrix(1:60, 6, 5), pheno = data.frame(age = 1:6)))
  init <- synthetic_initializer()

  dat2 <- synthetic_generator(dat, init)
  res <- get_seed(dat2)

  expect_true(length(res) == 1)
  expect_true(is.numeric(res))
  expect_true(res %% 1 == 0)
})

test_that("get_seed gives warning if applied on data that isn't synthetic", {
  set.seed(10)
  set.seed(10)
  mat <- matrix(rnorm(30), 5, 6)
  age <- 1:5
  gender <- as.factor(c("M", "F", "M", "M", "F"))
  pheno <- data.frame(age, gender)
  dat <- data_object(list(mat = mat, pheno = pheno))

  expect_warning(get_seed(dat))
})
