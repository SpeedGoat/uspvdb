# Build get query
get_ <- function(endpoint, range = NULL, exact = TRUE, limit = NULL,
                 offset = NULL, sort_by = NULL, filters = NULL, select = NULL,
                 debug = FALSE) {

  if (endpoint != "projects") {
    cli::cli_warn(
      "This package was developed using the documentation for the 'project'
      endpoint. If you are using another endpoint the results may not be as
      expected."
    )
  }

  resp <- httr2::request(base_url) %>%
    httr2::req_url_path_append(endpoint) %>%
    httr2::req_method("GET") %>%
    page_range(range, exact) %>%
    page_offset_limit(offset, limit) %>%
    sort_by_columns(sort_by) %>%
    filter_rows(filters) %>%
    filter_columns(select)
}

# Add pagination via range as header
page_range <- function(x, range = NULL, exact = TRUE) {
  if (is.null(range)) {
    return(x)
  }

  if (!inherits(exact, "logical")) {
    cli::cli_abort("Argument 'exact' must be TRUE or FALSE")
  }

  rng <- trimws(range)
  if (!grepl("^\\d+-\\d+$", rng)) {
    cli::cli_abort("Argument 'range' must be in the form 'start-end'")
  }

  x %>%
    httr2::req_headers(
      "Range" = rng,
      "Prefer" = paste0("count=", switch(exact, "exact"))
    )
}

# Add pagination as offset and limit
# https://eersc.usgs.gov/api/uspvdb/v1/projects?&offset=300&limit=50
page_offset_limit <- function(x, offset = NULL, limit = NULL) {

  if (is.null(offset) && is.null(limit)) {
    return(x)
  }

  if (is.null(limit) && !is.null(offset)) {
    cli::cli_abort("Argument 'offset' not meaningful if limit not provided")
  }

  if (!is.null(limit) && !is.null(offset)) {
    if (!inherits(offset, "numeric") || offset < 0 || length(offset) > 1) {
      cli::cli_abort("Argument 'offset' must be a non-negative integer")
    }
  }

  if (!inherits(limit, "numeric") || limit < 1 || length(limit) > 1) {
    cli::cli_abort("Argument 'limit' must be a positive integer")
  }

  httr2::req_url_query(
    x,
    offset = offset,
    limit = limit,
    .multi = "error"
  )

}

# Add sorting
# https://eersc.usgs.gov/api/uspvdb/v1/projects?&order=p_type.desc,p_year.asc
sort_by_columns <- function(x, sort_by = NULL) {
  if (is.null(sort_by)) {
    return(x)
  }

  if (!is.character(sort_by)) {
    cli::cli_abort("Argument 'sort_by' must be a character vector")
  }

  if (length(sort_by) != sum(names(sort_by) != "", na.rm = TRUE)) {
    cli::cli_abort("Argument 'sort_by' must be a named character vector")
  }

  if (!all(names(sort_by) %in% docs$key)) {
    cli::cli_warn(
      "For the projects endpoint the names in 'sort_by' must match a column in
      'docs' data column key. See `data(docs)`. If you are using another
      endpoint column names are not verified."
    )
  }

  if (!all(sort_by %in% c("asc", "desc"))) {
    cli::cli_abort("Argument 'sort_by' must be either 'asc' or 'desc'")
  }

  httr2::req_url_query(
    x,
    order = paste(names(sort_by), sort_by, sep = "."),
    .multi = "comma"
  )
}

# Add filtering
# See filter_operators in package internal data
# https://eersc.usgs.gov/api/uspvdb/v1/projects?&p_year=eq.2020&p_cap_ac=gt.100
filter_rows <- function(x, filters = NULL) {
  if (is.null(filters)) {
    return(x)
  }

  if (length(filters) != sum(names(filters) != "", na.rm = TRUE)) {
    cli::cli_abort("Argument 'filters' must be a named character vector")
  }

  if (!all(names(filters) %in% docs$key)) {
    cli::cli_warn(
      "For the projects endpoint the names in 'filters' must match a column in
      'docs' data column key. See `data(docs)`. If you are using another
      endpoint column names are not verified."
    )
  }

  valid_ops <- paste0(
    "^(", paste(filter_operators$operator, collapse = "|"), ")\\."
  )

  if (!all(grepl(valid_ops, filters))) {
    cli::cli_abort(
      c("Argument 'filters' must be in the form 'operator.value'.",
        "x" = "Found invalid operator: {filters[!grepl(valid_ops, filters)]}",
        "i" = "Valid operators are: {filter_operators$operator}")
    )
  }

  httr2::req_url_query(
    x,
    !!!as.list(filters),
    .multi = "explode"
  )

}

# Add column selection
# https://eersc.usgs.gov/api/uspvdb/v1/projects?&select=p_name,p_cap_ac,p_state
filter_columns <- function(x, select) {
  if (is.null(select)) {
    return(x)
  }

  if (!is.character(select)) {
    cli::cli_abort("Argument 'select' must be a character vector")
  }

  if (!all(select %in% docs$key)) {
    cli::cli_warn(
      "For the projects endpoint the names in 'select' must match a column in
      'docs' data column key. See `data(docs)`. If you are using another
      endpoint column names are not verified."
    )
  }

  httr2::req_url_query(
    x,
    select = select,
    .multi = "comma"
  )
}

