-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Moneda" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "simbolo" TEXT NOT NULL,
    "codigoISO" TEXT NOT NULL,
    "pais" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Moneda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Criptomoneda" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "simbolo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "algoritmo" TEXT,
    "website" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Criptomoneda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HistoricoMoneda" (
    "id" SERIAL NOT NULL,
    "idOriginal" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "simbolo" TEXT NOT NULL,
    "codigoISO" TEXT NOT NULL,
    "pais" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,
    "fechaHistorico" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HistoricoMoneda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HistoricoCriptomoneda" (
    "id" SERIAL NOT NULL,
    "idOriginal" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "simbolo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "algoritmo" TEXT,
    "website" TEXT,
    "activo" BOOLEAN NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,
    "fechaHistorico" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HistoricoCriptomoneda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_MonedaToCriptomoneda" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_MonedaToCriptomoneda_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Moneda_nombre_key" ON "Moneda"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Moneda_simbolo_key" ON "Moneda"("simbolo");

-- CreateIndex
CREATE UNIQUE INDEX "Moneda_codigoISO_key" ON "Moneda"("codigoISO");

-- CreateIndex
CREATE UNIQUE INDEX "Criptomoneda_nombre_key" ON "Criptomoneda"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Criptomoneda_simbolo_key" ON "Criptomoneda"("simbolo");

-- CreateIndex
CREATE INDEX "_MonedaToCriptomoneda_B_index" ON "_MonedaToCriptomoneda"("B");

-- AddForeignKey
ALTER TABLE "_MonedaToCriptomoneda" ADD CONSTRAINT "_MonedaToCriptomoneda_A_fkey" FOREIGN KEY ("A") REFERENCES "Criptomoneda"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MonedaToCriptomoneda" ADD CONSTRAINT "_MonedaToCriptomoneda_B_fkey" FOREIGN KEY ("B") REFERENCES "Moneda"("id") ON DELETE CASCADE ON UPDATE CASCADE;
