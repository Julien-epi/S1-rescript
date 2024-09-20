open Uniswap

let fetchPriceFromDex = async (tokenAddress: string, dex: string): Js.Promise.t<priceData> => {
  switch dex {
  | "uniswap" => await fetchPrice(tokenAddress)
  | _ => Js.Promise.reject(Js.Exn.raiseError("DEX non supporté"))
  }
}
