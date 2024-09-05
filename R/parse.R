#' Parse API response
#'
#' @param x A response object as created by calling 'get_*' function
#' @param data_type The type of data to parse. Default is 'json'. All documented
#' responses are JSON.
#'
#' @return tibble when data_type is json
#'
#' @examples
#' \dontrun{
#' x <- get_("projects")
#' parse(x)
#' }
parse <- function(x, data_type = "json") {
  if (httr2::resp_is_error(x)) {
    cli::cli_abort(
      c(
        "x" = httr2::resp_status(x),
        "!" = httr2::resp_status_desc(x)
      )
    )
  }

  # Implemented for future expansion
  switch(
    data_type,
    "json" = httr2::resp_body_json(x, simplifyDataFrame = T),
    "raw" = httr2::resp_body_raw(x),
    "string" = httr2::resp_body_string(x),
    "html" = httr2::resp_body_html(x),
    "xml" = httr2::resp_body_xml(x),
    cli::cli_abort(
      "x" = "Argument 'data_type' must be one of 'json', 'raw', 'string',
      'html', or 'xml'"
    )
  )
}
