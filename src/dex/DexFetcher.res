let fetchPrice = (tokenAddress: string, dex: string): Js.Promise.t<DexTypes.priceData> => {
  switch dex {
  | "uniswap" => Uniswap.fetchPrice(tokenAddress)
  | _ => Js.Promise.reject(Js.Exn.raiseError("DEX non supporté"))
  }
}