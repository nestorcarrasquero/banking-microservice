import express from 'express'
import { PORT } from './config.js'
import prisma from './lib/prisma.js'

const app = express()

app.use(express.json())

app.post('/api/history', async (req, res) => {
  try {
    await historicData()
    res.status(200).json({ message: 'Proceso de respaldo en historico iniciado' })
  } catch (error) {
    console.error('Error en el proceso de respaldo ', error)
    res.status(500).json({ error: 'Error en el servicio' })
  }
})

async function historicData () {
  const now = new Date()
  const fechaLimite = new Date(now.setDate(now.getDate()))
  try {
    await prisma.$transaction(async (tx) => {
      const moneyToMove = await tx.moneda.findMany({
        where: {
          fechaCreacion: {
            lt: fechaLimite
          }
        }
      })

      console.log(`Moviendo ${moneyToMove.length} registros de monedas`)

      await tx.historicoMoneda.createMany({
        data: moneyToMove.map((money) => ({
          fechaHistorico: new Date(),
          idOriginal: money.id,
          nombre: money.nombre,
          simbolo: money.simbolo,
          codigoISO: money.codigoISO,
          pais: money.pais,
          activo: money.activo,
          fechaCreacion: money.fechaCreacion,
          fechaActualizacion: money.fechaActualizacion
        })),
        skipDuplicates: true
      })

      const idsMoney = moneyToMove.map(p => p.id)

      await tx.moneda.deleteMany({
        where: {
          id: {
            in: idsMoney
          }
        }
      })

      console.log(`Se han movido ${moneyToMove.length} registros de monedas`)

      const cryptoToMove = await tx.criptomoneda.findMany({
        where: {
          fechaCreacion: {
            lt: fechaLimite
          }
        }
      })

      console.log(`Moviendo ${cryptoToMove.length} registros de criptomonedas`)

      await tx.historicoCriptomoneda.createMany({
        data: cryptoToMove.map((money) => ({
          fechaHistorico: new Date(),
          idOriginal: money.id,
          nombre: money.nombre,
          simbolo: money.simbolo,
          codigoISO: money.codigoISO,
          pais: money.pais,
          activo: money.activo,
          fechaCreacion: money.fechaCreacion,
          fechaActualizacion: money.fechaActualizacion
        })),
        skipDuplicates: true
      })

      const idsCripto = cryptoToMove.map(p => p.id)

      await tx.criptomoneda.deleteMany({
        where: {
          id: {
            in: idsCripto
          }
        }
      })

      console.log(`Se han movido ${cryptoToMove.length} registros de criptomonedas`)
      console.log('Proceso completado exitosamente')
    })
  } catch (error) {
    console.error(error)
    throw error
  }
}

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`)
})
