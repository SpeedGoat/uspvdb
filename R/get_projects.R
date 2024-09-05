#' Wrapper function to ease calling of USPVDB projects endpoint
#'
#' @param range used for pagination, in the form 'start-end', see examples
#' @param limit total number of records to return
#' @param offset number of records to skip before applying the limit
#' @param sort_by used to sort the results, the argument takes the form of a
#' named vector where the names are the columns to sort and the values are the
#' direction of the sort (asc or desc), see examples
#' @param filters used to filter the results, the argument takes the form of a
#' named vector where the names are the columns to filter and the values are the
#' values to filter on prepended by a valid operator, see examples
#' @param select used to filter the columns to return, the argument takes a
#' simple character vector of column names
#' @param verbosity control the level of information printed to the console,
#' defaults to 0, which means do not provide any output
#' @param debug logical, if TRUE the request is not performed, but is printed to
#' the console, default is FALSE
#'
#' @return tibble
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Get all projects
#' get_projects()
#'
#' # Get the first 10 rows
#' get_projects(limit = 10)
#'
#' # Get the first 10 rows, skipping the first 10
#' get_projects(limit = 10, offset = 10)
#'
#' # Get the first 10 rows, skipping the first 10, and only return the
#' #  'project_id'
#' get_projects(limit = 10, offset = 10, select = "case_id")
#'
#' # Get 10 rows sorted by case_id
#' get_projects(limit = 10, sort_by = c(case_id = "asc"))
#'
#' # Get 10 rows filtered to where ylat is greater than 40
#' get_projects(limit = 10, filters = c(ylat = "gt.40"))
#'
#' # Get 10 rows where multi_poly equals single
#' get_projects(limit = 10, filters = c(multi_poly = "eq.single"))
#'
#' # Get 10 rows and only return the coordinates of the project
#' get_projects(limit = 10, select = c("xlong", "ylat"))
#'
#' # Show the call from the last example
#' get_projects(limit = 10, select = c("xlong", "ylat"), debug = TRUE)
#'
#' }
get_projects <- function(range = NULL, limit = NULL,
                         offset = NULL, sort_by = NULL, filters = NULL,
                         select = NULL, verbosity = 0, debug = FALSE) {
    result <- get_(
        endpoint = "projects",
        range = range,
        exact = TRUE,
        limit = limit,
        offset = offset,
        sort_by = sort_by,
        filters = filters,
        select = select,
        debug = debug
      ) %>%
      perform(debug = debug, verbosity)

  if (debug) {
    out <- result
  } else {
    out <- parse(result, data_type = "json")
  }

  out
}
