#' Perform a request
#'
#' Intended to be used internal to the package.
#'
#' @param call A request object as created by 'httr2::request()'
#' @param debug If TRUE, the request is not actually performed, but a dry run is
#' shown instead. This is useful in debugging. Default is FALSE.
#' @param verbosity The level of information to print to the users console. See
#' ?httr2::req_perform for details. Default is 3.
#'
#' @return A response object
#'
#' @examples
#' \dontrun{
#' req <- httr2::request("https://httpbin.org/get")
#' perform(req, TRUE)
#' perform(req)
#' }
perform <- function(call, debug = FALSE, verbosity = 3) {
  if (!inherits(call, "httr2_request")) {
    cli::cli_abort(
      "Argument 'call' must be a request object created by 'httr2::request()'"
    )
  }

  if (debug) {
    out <- httr2::req_dry_run(call)
  } else {
    out <- httr2::req_perform(call, verbosity = verbosity)
  }
  out
}
