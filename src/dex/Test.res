// Importation des modules nécessaires
@module("@uniswap/sdk-core") external Token: (int, string, int, string, string) => uniswapToken = "Token"
@module("@uniswap/v3-sdk") external computePoolAddress: {"factoryAddress": string, "tokenA": uniswapToken, "tokenB": uniswapToken, "fee": int} => string = "computePoolAddress"
@module("ethers") external jsonRpcProvider: string => provider = "JsonRpcProvider"
@module("ethers") external contract: (string, Js.Json.t, provider) => contract = "Contract"
@module("@uniswap/v3-core/artifacts/contracts/interfaces/IUniswapV3Pool.sol/IUniswapV3Pool.json") external iUniswapV3PoolABI: Js.Json.t = "IUniswapV3Pool"
@module("@uniswap/v3-periphery/artifacts/contracts/lens/Quoter.sol/Quoter.json") external quoter: Js.Json.t = "Quoter"

// Définition de l'interface ExampleConfig en ReScript
type rpc = {
  local: string,
  mainnet: string
}

type tokens = {
  in_: uniswapToken,
  amountIn: float,
  out: uniswapToken,
  poolFee: int
}

type exampleConfig = {
  rpc: rpc,
  tokens: tokens
}

// Définition des tokens WETH et USDC
let wethToken = Token(1, "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", 18, "WETH", "Wrapped Ether")
let usdcToken = Token(1, "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", 6, "USDC", "USD//C")

// Définition de la configuration
let currentConfig: exampleConfig = {
  rpc: {
    local: "http://localhost:8545",
    mainnet: "https://mainnet.infura.io/v3/0ac57a06f2994538829c14745750d721"
  },
  tokens: {
    in_: usdcToken,
    amountIn: 1000.0,
    out: wethToken,
    poolFee: 3000 // Correspond à FeeAmount.MEDIUM (0.3%)
  }
}

// Calcul de l'adresse du pool Uniswap V3
let poolFactoryContractAddress = "POOL_FACTORY_CONTRACT_ADDRESS"
let currentPoolAddress = computePoolAddress({
  factoryAddress: poolFactoryContractAddress,
  tokenA: currentConfig.tokens.in_,
  tokenB: currentConfig.tokens.out,
  fee: currentConfig.tokens.poolFee
})

// Connexion au provider via ethers
let rpcUrl = currentConfig.rpc.mainnet
let provider = jsonRpcProvider(rpcUrl)

// Connexion au contrat du pool Uniswap V3
let poolContract = contract(currentPoolAddress, iUniswapV3PoolABI, provider)

// Récupération des informations du pool (token0, token1, etc.)
let getPoolData = () => {
  Js.Promise.all([
    poolContract.token0(),
    poolContract.token1(),
    poolContract.fee(),
    poolContract.liquidity(),
    poolContract.slot0(),
  ])
  |> Js.Promise.then_(result => {
       let [token0, token1, fee, liquidity, slot0] = result
       Js.log("Pool data:", (token0, token1, fee, liquidity, slot0))
       Js.Promise.resolve()
     })
}

// Connexion au contrat du Quoter pour obtenir des estimations de swaps
let quoterContractAddress = "QUOTER_CONTRACT_ADDRESS"
let quoterContract = contract(quoterContractAddress, quoter, provider)

// Fonction pour obtenir une estimation du swap
let quoteExactInputSingle = () => {
  quoterContract.callStatic.quoteExactInputSingle(
    currentConfig.tokens.in_.address,
    currentConfig.tokens.out.address,
    currentConfig.tokens.poolFee,
    currentConfig.tokens.amountIn->Js.Float.toString,
    0
  )
  |> Js.Promise.then_(quotedAmountOut => {
       Js.log("Quoted Amount Out:", quotedAmountOut)
       Js.Promise.resolve()
     })
}

// Appel des fonctions pour tester
getPoolData()
quoteExactInputSingle()

// Utilisation de la fonction fetch
open Fetch

let fetchRequest = async (url, query) => {
  let response = await fetch(
    url,
    RequestInit.make(
      ~method_=#post,
      ~body=BodyInit.make(JSON.stringify(query)),
      ()
    )
  )
  let result = await response->Response.json
  Js.log(result)
}
