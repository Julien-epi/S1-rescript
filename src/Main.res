open ParaSwapApi

let formatAmount = (amountStr: string, decimals: int): string => {
  let len = Js.String2.length(amountStr)
  if len <= decimals {
    let zerosNeeded = decimals - len
    let zeros = Js.String2.repeat("0", zerosNeeded)
    "0." ++ zeros ++ amountStr
  } else {
    let integerPart = Js.String2.slice(~from=0, ~to_=len - decimals, amountStr)
    let fractionalPart = Js.String2.slice(~from=len - decimals, ~to_=len, amountStr)
    integerPart ++ "." ++ fractionalPart
  }
}

let _ = {
  let fromToken = "ETH"
  let toToken = "DAI"
  let amount = "1000000000000000000"
  let paraSwapUrl = "https://apiv5.paraswap.io/swap"
  let slippage = "1" 
  let userAddress = "0xc03Fa33F7E9EA5EF7a2b5ecfa6533ad80Eb358A0"

  let swapDetailsPromise = getSwapDetails(~fromToken, ~toToken, ~amount, ~paraSwapUrl, ~slippage, ~userAddress)

  swapDetailsPromise
  |> Js.Promise.then_(res => {
       switch res {
       | Ok(data) => {
           Js.Console.log("Swap rate data:")
           let decimals = 18
           let formattedAmount = formatAmount(data.priceRoute.destAmount, decimals)
           Js.Console.log("Montant reçu : " ++ formattedAmount ++ " " ++ toToken)
           Js.Promise.resolve()
         }
       | Error(err) => {
           Js.Console.error("Error fetching swap rate:")
           Js.Console.error(err)
           Js.Promise.resolve()
         }
       }
     })
  |> ignore
}
