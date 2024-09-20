open Fetch

type priceData = {
  token0Price: string,
  token1Price: string,
}

let fetchPrice = async (tokenAddress: string): Js.Promise.t<priceData> => {
  let url = "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2"
  let query = {
    "query": `{ pair(id: "${tokenAddress}") { token0Price, token1Price } }`
  }

  let response = await Fetch.Fetch(
    url,
    Fetch.RequestInit.make(~method_=#post, ~body=Fetch.BodyInit.make(JSON.stringify(query)), ())
  )

  let json = await response->Fetch.Response.json

  switch Js.Json.decodeObject(json) {
  | Some(obj) =>
    switch Js.Dict.get(obj, "data") {
    | Some(data) => Js.Promise.resolve(data,pair)
    | None => Js.Promise.reject(Js.Exn.raiseError("Error: No data found"))
    }
  | None => Js.Promise.reject(Js.Exn.raiseError("Error: Invalid JSON format"))
  }
}
