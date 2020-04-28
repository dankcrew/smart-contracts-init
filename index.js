const fetch = require("node-fetch")
const fs = require("fs")
const Web3 = require("web3")
const {
    Contract,
    ContractFactory,
    utils: {computeAddress, parseEther, formatEther},
    Wallet,
    providers: {Web3Provider}
} = require("ethers")


const TokenJson = require("./TestToken.json")
const MarketplaceJson = require("./Marketplace.json")
const Marketplace2Json = require("./Marketplace2.json")
const UniswapAdaptor = require("./UniswapAdaptor.json")
const SimpleTrackerRegistry = require("./SimpleTrackerRegistry.json")
const uniswap_exchange_abi = JSON.parse(fs.readFileSync("./abi/uniswap_exchange.json", "utf-8"))
const uniswap_factory_abi = JSON.parse(fs.readFileSync("./abi/uniswap_factory.json", "utf-8"))
const uniswap_exchange_bytecode = fs.readFileSync("./bytecode/uniswap_exchange.txt", "utf-8")
const uniswap_factory_bytecode = fs.readFileSync("./bytecode/uniswap_factory.txt", "utf-8")
const chainURL = process.env.CHAIN_URL || "http://localhost:8545"
const streamrUrl = process.env.EE_URL || "http://localhost:8081/streamr-core" // production: "https://www.streamr.com"
const log = process.env.QUIET ? (() => {
}) : console.log // eslint-disable-line no-console
const futureTime = 4449513600

// Default Private Key
defaultPrivateKey = "0x5e98cce00cff5dea6b454889f359a4ec06b9fa6b88e9d69b86de8e1c81887da0"

const privateKeys = [
    "0x5e98cce00cff5dea6b454889f359a4ec06b9fa6b88e9d69b86de8e1c81887da0",
    "0xe5af7834455b7239881b85be89d905d6881dcb4751063897f12be1b0dd546bdb",
    "0x4059de411f15511a85ce332e7a428f36492ab4e87c7830099dadbf130f1896ae",
    "0x633a182fb8975f22aaad41e9008cb49a432e9fdfef37f151e9e7c54e96258ef9",
    "0x957a8212980a9a39bf7c03dcbeea3c722d66f2b359c669feceb0e3ba8209a297",
    "0xfe1d528b7e204a5bdfb7668a1ed3adfee45b4b96960a175c9ef0ad16dd58d728",
    "0xd7609ae3a29375768fac8bc0f8c2f6ac81c5f2ffca2b981e6cf15460f01efe14",
    "0xb1abdb742d3924a45b0a54f780f0f21b9d9283b231a0a0b35ce5e455fa5375e7",
    "0x2cd9855d17e01ce041953829398af7e48b24ece04ff9d0e183414de54dc52285",
    "0x2c326a4c139eced39709b235fffa1fde7c252f3f7b505103f7b251586c35d543",
]

async function getProducts() {
    return await (await fetch(`${streamrUrl}/api/v1/products?publicAccess=true`)).json()
}
function sleep(ms) {
    return new Promise(resolve => {
        setTimeout(resolve, ms)
    })
}

async function smartContractInitialization() {

    // wait until ganache is up and ethers.js ready
    const web3 = new Web3(chainURL)
    let provider = await new Web3Provider(web3.currentProvider);
    try {
        await provider.getNetwork()
    } catch (e) {
        console.error(e)
        process.exit(1)
    }

    const wallet = new Wallet(defaultPrivateKey, provider)

    log(`Deploying test DATAcoin from ${wallet.address}`)
    const tokenDeployer = await new ContractFactory(TokenJson.abi, TokenJson.bytecode, wallet)
    const tokenDeployTx = await tokenDeployer.deploy("Test DATAcoin", "\ud83e\udd84")
    const token = await tokenDeployTx.deployed()
    log(`DATACOIN ERC20 deployed at ${token.address}`)

    log(`Deploying Marketplace1 contract from ${wallet.address}`)
    const marketDeployer1 = new ContractFactory(MarketplaceJson.abi, MarketplaceJson.bytecode, wallet)
    const marketDeployTx1 = await marketDeployer1.deploy(token.address, wallet.address)
    const market1 = await marketDeployTx1.deployed()
    log(`Marketplace1 deployed at ${market1.address}`)

    log(`Deploying Marketplace2 contract from ${wallet.address}`)
    const marketDeployer2 = new ContractFactory(Marketplace2Json.abi, Marketplace2Json.bytecode, wallet)
    const marketDeployTx2 = await marketDeployer2.deploy(token.address, wallet.address, market1.address)
    const market = await marketDeployTx2.deployed()
    log(`Marketplace2 deployed at ${market.address}`)

    log(`Deploying Uniswap Factory contract from ${wallet.address}`)
    const uniswapFactoryDeployer = new ContractFactory(uniswap_factory_abi, uniswap_factory_bytecode, wallet)
    const uniswapFactoryDeployTx = await uniswapFactoryDeployer.deploy()
    const uniswapFactory = await uniswapFactoryDeployTx.deployed()
    log(`Uniswap factory deployed at ${uniswapFactory.address}`)

    log(`Deploying Uniswap Exchange template contract from ${wallet.address}`)
    const uniswapExchangeDeployer = new ContractFactory(uniswap_exchange_abi, uniswap_exchange_bytecode, wallet)
    const uniswapExchangeDeployTx = await uniswapExchangeDeployer.deploy()
    const uniswapExchangeTemplate = await uniswapExchangeDeployTx.deployed()
    log(`Uniswap exchange template deployed at ${uniswapExchangeTemplate.address}`)

    log(`Deploying UniswapAdaptor contract from ${wallet.address}`)
    const uniswapAdaptorDeployer = new ContractFactory(UniswapAdaptor.abi, UniswapAdaptor.bytecode, wallet)
    const uniswapAdaptorDeployTx = await uniswapAdaptorDeployer.deploy(market.address, uniswapFactory.address, token.address)
    const uniswapAdaptor = await uniswapAdaptorDeployTx.deployed()
    log(`UniswapAdaptor deployed at ${uniswapAdaptor.address}`)

    //another ERC20 that's not datacoin for testing buy with Uniswap
    log(`Deploying test OTHERcoin from ${wallet.address}`)
    const tokenDeployer2 = new ContractFactory(TokenJson.abi, TokenJson.bytecode, wallet)
    const tokenDeployTx2 = await tokenDeployer2.deploy("Test OTHERcoin", "\ud83e\udd84")
    const token2 = await tokenDeployTx2.deployed()

    log("Minting 1000000 tokens to following addresses:")
    for (const address of privateKeys.map(computeAddress)) {
        log("    " + address)
        const mintTx = await token.mint(address, "1000000")
        await mintTx.wait()
    }

    log("Init Uniswap factory")
    let tx = await uniswapFactory.initializeFactory(uniswapExchangeTemplate.address)
    await tx.wait()
    log(`Init Uniswap exchange for DATAcoin token ${token.address}`)
    tx = await uniswapFactory.createExchange(token.address, {gasLimit: 6000000})
    await tx.wait()
    log(`Init Uniswap exchange for OTHERcoin token ${token2.address}`)
    tx = await uniswapFactory.createExchange(token2.address, {gasLimit: 6000000})
    await tx.wait()

    let datatoken_exchange_address = await uniswapFactory.getExchange(token.address)
    log(`DATAcoin traded at Uniswap exchange ${datatoken_exchange_address}`)
    let othertoken_exchange_address = await uniswapFactory.getExchange(token2.address)
    log(`OTHERcoin traded at Uniswap exchange ${othertoken_exchange_address}`)
    let datatokenExchange = new Contract(datatoken_exchange_address, uniswap_exchange_abi, wallet)
    let othertokenExchange = new Contract(othertoken_exchange_address, uniswap_exchange_abi, wallet)

    // wallet starts with 1000 ETH and 100000 of each token
    // add 10 ETH liquidity to tokens, set initial exchange rates
    let amt_eth = parseEther("40")
    let amt_token = parseEther("1000") // 1 ETH ~= 10 DATAcoin
    let amt_token2 = parseEther("10000") // 1 ETH ~= 100 OTHERcoin

    tx = await token.approve(datatoken_exchange_address, amt_token)
    await tx.wait()
    tx = await token2.approve(othertoken_exchange_address, amt_token2)
    await tx.wait()

    tx = await datatokenExchange.addLiquidity(amt_token, amt_token, futureTime, {gasLimit: 6000000, value: amt_eth})
    await tx.wait()
    tx = await othertokenExchange.addLiquidity(amt_token2, amt_token2, futureTime, {gasLimit: 6000000, value: amt_eth})
    await tx.wait()
    log(`Added liquidity to uniswap exchange: ${formatEther(amt_token)} DATAcoin, ${formatEther(amt_token2)} OTHERcoin`)
    const ethwei = parseEther("1")
    let rate = await datatokenExchange.getTokenToEthInputPrice(ethwei)
    log(`1 DATAtoken buys ${formatEther(rate)} ETH`)
    rate = await othertokenExchange.getTokenToEthInputPrice(ethwei)
    log(`1 OTHERtoken buys ${formatEther(rate)} ETH`)

    log(`Deploying SimpleTrackerRegistry contract from ${wallet.address}`)
    const strDeploy = new ContractFactory(SimpleTrackerRegistry.abi, SimpleTrackerRegistry.bytecode, wallet)
    const strDeployTx = await strDeploy.deploy(wallet.address, false, {gasLimit: 6000000} )
    const str = await strDeployTx.deployed()
    log(`SimpleTrackerRegistry deployed at ${str.address}`)
    tx = await str.createOrUpdateNode('0xb9e7cEBF7b03AE26458E32a059488386b05798e8', 'ws://10.200.10.1:30301')
    await tx.wait()
    tx = await str.createOrUpdateNode('0x0540A3e144cdD81F402e7772C76a5808B71d2d30', 'ws://10.200.10.1:30302')
    await tx.wait()
    tx = await str.createOrUpdateNode('0xf2C195bE194a2C91e93Eacb1d6d55a00552a85E2', 'ws://10.200.10.1:30303')
    await tx.wait()
    let nodes = await str.getNodes();
    log(`TrackerRegistry nodes : ${JSON.stringify(nodes)}`)

    const EEwaitms = 60000
    log("Getting products from E&E")
    log(`waiting ${EEwaitms}ms for E&E to start`)
    await sleep(EEwaitms)
    // this get the products and also checks if EE is up
    let products
    try {
        products = await getProducts()
    } catch (e) {
        console.error(e)
        process.exit(1)
    }


    log(`Adding ${products.length} products to Marketplace`)
    for (const p of products) {
        // free products not supported
        if (p.pricePerSecond == 0) {
            continue
        }

        const tx = await market.createProduct(`0x${p.id}`, p.name, wallet.address, p.pricePerSecond, p.priceCurrency == "DATA" ? 0 : 1, p.minimumSubscriptionInSeconds)
        await tx.wait(1)
        if (p.state == "NOT_DEPLOYED") {
            const tx2 = await market.deleteProduct(`0x${p.id}`)
            await tx2.wait(1)
        }
    }
}

smartContractInitialization()
