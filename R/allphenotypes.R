#' Get all phenotypes, their variations, and how many users have data
#' 		available for a given phenotype.
#'
#' Either return data.frame with all results, or output a list, then call
#' 		the charicteristic by id (paramater = "id") or name (paramater =
#' 		"characteristic").
#'
#' @export
#' @param df Return a data.frame of all data. The column known_variations
#' 		can take multiple values, so the other columns id, characteristic, and
#' 		number_of_users are replicated in the data.frame. (default = FALSE)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @return Data.frame of results, or list if df=FALSE
#' @examples \dontrun{
#' # Get all data
#' allphenotypes(df = TRUE)
#'
#' # Output a list, then call the characterisitc of interest by 'id' or
#' # 'characteristic'
#' datalist <- allphenotypes()
#' names(datalist) # get list of all characteristics you can call
#' datalist[["ADHD"]] # get data.frame for 'ADHD'
#' datalist[c("mouth size","SAT Writing")] # get data.frame for 'ADHD'
#' }

allphenotypes <- function(df = FALSE, ...) {
  res <- GET(paste0(osnp_base(), "phenotypes.json"), ...)
  stop_for_status(res)
  out <- cuf8(res)
  out <- jsonlite::fromJSON(out, simplifyVector = FALSE)
  if (df) {
    ldply(out, function(x) data.frame(do.call(cbind, x),
                                      stringsAsFactors = FALSE))
  } else {
    temp <- lapply(out, function(x) data.frame(do.call(cbind, x),
                                               stringsAsFactors = FALSE))
    cs <- str_trim(
      str_replace_all(
        sapply(out, function(x) x$characteristic), '\\(|\\)', ''), side = "both")
    names(temp) <- cs
    temp
  }
}
