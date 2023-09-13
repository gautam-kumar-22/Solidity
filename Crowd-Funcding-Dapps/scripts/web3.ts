
export const deploy = async (contractName: string, arguments: Array<any>, from?: string, gas?: number) => {
    
    console.log(`deploying ${contractName}`)
    // Note that the script needs the ABI which is generated from the compilation artifact.
    // Make sure contract is compiled and artifacts are generated
    const artifactsPath = `browser/contracts/artifacts/${contractName}.json` // Change this for different path

    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', artifactsPath))

    const accounts = await web3.eth.getAccounts()

    let contract = new web3.eth.Contract(metadata.abi)

    contract = contract.deploy({
        data: metadata.data.bytecode.object,
        arguments
    })

    const newContractInstance = await contract.send({
        from: from || accounts[0],
        gas: gas || 1500000
    })
    return newContractInstance.options    
}: Promise<any>