import { Executable, FileWriter } from '@rushstack/node-core-library'
import * as PropertiesReader from 'properties-reader'

console.log('Executing cf env')

const raw = Executable.spawnSync('cf', ['env', 'btp-trial-srv']).stdout.split('\n\n')

const vcapEnvRaw = raw[0]
const vcapEnv = vcapEnvRaw.slice(vcapEnvRaw.indexOf('VCAP_SERVICES:'), vcapEnvRaw.length).split('VCAP_SERVICES:')[1]
const vcap = JSON.stringify(JSON.parse(vcapEnv))

const envRaw = raw[2]

// const file = FileWriter.open(`${__dirname}/../.env`, { append: true })

const filePath = `${__dirname}/../.env`

const b = envRaw.replace('User-Provided:', '')
let currentKey
const env = b
  .split('\n')
  .slice(2)
  .reduce((acc, curr) => {
    const matcher = curr.match(/^[^"]\w.*[^"]:/gi)
    if (matcher) {
      const arr = curr.split(':')
      acc[arr[0]] = arr[1].trim()
      currentKey = arr[0]
      return acc
    }
    acc[currentKey] += curr.trim()
    return acc
  }, {} as Record<string, string>)

console.log('Reading properties')
const reader = PropertiesReader(filePath, 'utf8', {
  writer: { saveSections: true },
  allowDuplicateSections: false,
})

console.log('Saving properties')

reader.set('LOCAL_DEV', 'true')
Object.entries(env).map(([key, value]) => reader.set(key, value.startsWith('{') ? `'${value}'` : value))
reader.set('VCAP_SERVICES', `'${vcap}'`)

reader
  .save(filePath, process.exit)
  .catch((err) => {
    console.error(err)
    process.exit(1)
  })
