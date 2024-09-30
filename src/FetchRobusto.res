module Internal = Core

let useFetch = (domainName: string, headers: Dict.t<string>) => {
  {
    "get": Internal.get(domainName, headers),
    "post": Internal.create(domainName, headers),
    "put": Internal.update(domainName, headers),
    "delete": Internal.delete_(domainName, headers),
  }
}