let fetchPrice = (tokenAddress: string): Js.Promise.t<DexTypes.priceData> => {
  let url = "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2"
  let query = {
    "query": `{ pair(id: "${tokenAddress}") { token0Price, token1Price } }`
  }

  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(~method_=#post, ~body=Fetch.BodyInit.make(JSON.stringify(query)), ())
  )
  ->Js.Promise.then_(res => res->Fetch.Response.json)
  ->Js.Promise.then_(json => {
    switch Js.Json.decodeObject(json) {
    | Some(obj) =>
      switch Js.Dict.get(obj, "data") {
      | Some(data) => Js.Promise.resolve(data, pair)
      | None => Js.Promise.reject(Js.Exn.raiseError("Error: No data found"))
      }
    | None => Js.Promise.reject(Js.Exn.raiseError("Error: Invalid JSON format"))
    }
  })
}
