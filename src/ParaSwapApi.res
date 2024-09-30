open FetchRobusto

type priceRoute = {
  destAmount: string,
  srcAmount: string,
}

type paraSwapResponse = {
  priceRoute: priceRoute,
}

let parserParaSwapResponse = (response: string): result<paraSwapResponse, string> => {
  try {
    let json = Js.Json.parseExn(response)
    Js.Console.log("Raw API response: " ++ Js.Json.stringify(json)) 
    switch Js.Json.decodeObject(json) {
    | Some(obj) =>
        switch Js.Dict.get(obj, "error") {
        | Some(errorJson) =>
            let errorMessage = Belt.Option.getWithDefault(
              Js.Json.decodeString(errorJson),
              "Unknown error"
            )
            Error("API error: " ++ errorMessage)
        | None =>
            switch Js.Dict.get(obj, "priceRoute") {
            | Some(priceRouteJson) =>
                switch Js.Json.decodeObject(priceRouteJson) {
                | Some(priceObj) =>
                    let destAmountOpt = Js.Dict.get(priceObj, "destAmount")
                    let srcAmountOpt = Js.Dict.get(priceObj, "srcAmount")

                    switch (destAmountOpt, srcAmountOpt) {
                    | (Some(destJson), Some(srcJson)) =>
                        switch (Js.Json.decodeString(destJson), Js.Json.decodeString(srcJson)) {
                        | (Some(destStr), Some(srcStr)) =>
                            Ok({
                              priceRoute: {
                                destAmount: destStr,
                                srcAmount: srcStr,
                              }
                            })
                        | _ =>
                            Error("Invalid destAmount or srcAmount format")
                        }
                    | _ =>
                        Error("Missing destAmount or srcAmount in priceRoute")
                    }
                | None => Error("priceRoute is not an object")
                }
            | None => Error("Missing priceRoute in response")
            }
        }
    | None => Error("Expected a JSON object")
    }
  } catch {
  | _ => Error("Invalid JSON")
  }
}

let getSwapDetails = (~fromToken, ~toToken, ~amount, ~paraSwapUrl, ~slippage, ~userAddress) => {
  let fromTokenAddress = switch fromToken {
  | "ETH" => "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
  | "DAI" => "0x6B175474E89094C44Da98b954EedeAC495271d0F"
  | _ => failwith("Unsupported fromToken: " ++ fromToken)
  }

  let toTokenAddress = switch toToken {
  | "ETH" => "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
  | "DAI" => "0x6B175474E89094C44Da98b954EedeAC495271d0F"
  | _ => failwith("Unsupported toToken: " ++ toToken)
  }

  let queryParams =
    "?srcToken=" ++ fromTokenAddress ++
    "&destToken=" ++ toTokenAddress ++
    "&amount=" ++ amount ++
    "&side=SELL" ++
    "&network=1" ++
    "&version=6.2" ++
    "&slippage=" ++ slippage ++
    "&userAddress=" ++ userAddress 

  let headers = Js.Dict.empty()

  let fetchInstance = useFetch(paraSwapUrl, headers)

  fetchInstance["get"](queryParams, parserParaSwapResponse)
}
