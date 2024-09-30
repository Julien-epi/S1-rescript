open Webapi
open Promise

let get = (domainUrl: string, headers: Dict.t<string>) => async (
  path: string,
  parser: string => result<'a, string>,
) => {
  await Fetch.fetchWithInit(
    String.concat(domainUrl, path),
    Fetch.RequestInit.make(~method_=Get, ~headers=Fetch.HeadersInit.makeWithDict(headers), ()),
  )
  ->then(Fetch.Response.text)
  ->then(res => {
    switch parser(res) {
    | Ok(parsedData) => Promise.resolve(Ok(parsedData))
    | Error(parseError) => Promise.resolve(Error(parseError))
    }
  })
  ->catch(_ => Promise.resolve(Error("Network error")))
}

let create = (domainUrl: string, headers: Dict.t<string>) => async (path: string, body: 'a) => {
  await Fetch.fetchWithInit(
    String.concat(domainUrl, path),
    Fetch.RequestInit.make(
      ~method_=Post,
      ~headers=Fetch.HeadersInit.makeWithDict(headers),
      ~body=Fetch.BodyInit.make(Js.Json.stringify(body)),
      (),
    ),
  )
  ->then(Fetch.Response.text)
  ->then(res => {
    Promise.resolve(Ok(res))
  })
  ->catch(_ => Promise.resolve(Error("Network error")))
}

let update = (domainUrl: string, headers: Dict.t<string>) => async (path: string, body: 'a) => {
  await Fetch.fetchWithInit(
    String.concat(domainUrl, path),
    Fetch.RequestInit.make(
      ~method_=Put,
      ~headers=Fetch.HeadersInit.makeWithDict(headers),
      ~body=Fetch.BodyInit.make(Js.Json.stringify(body)),
      (),
    ),
  )
  ->then(Fetch.Response.text)
  ->then(res => {
    Promise.resolve(Ok(res))
  })
  ->catch(_ => Promise.resolve(Error("Network error")))
}

let delete_ = (domainUrl: string, headers: Dict.t<string>) => async (path: string) => {
  await Fetch.fetchWithInit(
    String.concat(domainUrl, path),
    Fetch.RequestInit.make(~method_=Delete, ~headers=Fetch.HeadersInit.makeWithDict(headers), ()),
  )
  ->then(Fetch.Response.text)
  ->then(res => {
    Promise.resolve(Ok(res))
  })
  ->catch(_ => Promise.resolve(Error("Network error")))
}