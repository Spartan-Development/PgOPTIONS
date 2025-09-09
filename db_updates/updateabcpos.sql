-- 1. Users Table (Authentication)
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    usuario VARCHAR(255) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('admin', 'user', 'seniat')) DEFAULT 'user',
    org_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Organization Info Table (moved up for foreign key references)
CREATE TABLE org (
    org_id SERIAL PRIMARY KEY,
    nombre_organizacion VARCHAR(255) NOT NULL,
    numero_identificacion VARCHAR(20) NOT NULL,
    tipo_identificacion CHAR(1) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    pais CHAR(2) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo_electronico VARCHAR(100),
    sitio_web VARCHAR(100),
    regimen_esp_tributacion VARCHAR(255),
    logo BYTEA,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Sellers Table
CREATE TABLE vendedor (
    vendedor_id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    num_cajero VARCHAR(20) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Buyers Table
CREATE TABLE comprador (
    comprador_id SERIAL PRIMARY KEY,
    tipo_identificacion CHAR(1) NOT NULL,
    numero_identificacion VARCHAR(20) NOT NULL,
    razon_social VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    pais CHAR(2) NOT NULL,
    notificar CHAR(2) NOT NULL CHECK (notificar IN ('SI', 'NO')),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Withheld Subjects Table
CREATE TABLE sujeto_retencion (
    sujeto_retencion_id SERIAL PRIMARY KEY,
    tipo_identificacion CHAR(1) NOT NULL,
    numero_identificacion VARCHAR(20) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    pais CHAR(2) NOT NULL,
    notificar CHAR(2) NOT NULL CHECK (notificar IN ('SI', 'NO')),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Documents Table (Core)
CREATE TABLE documento (
    documento_id SERIAL PRIMARY KEY,
    tipo_documento CHAR(2) NOT NULL,
    numero_documento VARCHAR(19) NOT NULL,
    
    --USED FOR CREDIT NOTES AND DEBIT NOTES
    serie_factura_afectada VARCHAR(10),
    numero_factura_afectada VARCHAR(19),
    fecha_factura_afectada DATE,
    monto_factura_afectada DECIMAL(20,2),

    comentario_factura_afectada VARCHAR(255),
    fecha_emision DATE NOT NULL,
    hora_emision TIME NOT NULL,
    tipo_de_pago VARCHAR(20) NOT NULL,
    serie VARCHAR(10),
    moneda CHAR(3) NOT NULL,
    es_iva CHAR(1),
    regimen_esp_tributacion VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    codigo_control VARCHAR(50),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Foreign keys
    vendedor_id INTEGER REFERENCES vendedor(vendedor_id),
    comprador_id INTEGER REFERENCES comprador(comprador_id),
    sujeto_retenido_id INTEGER REFERENCES sujeto_retencion(sujeto_retencion_id)
);

-- 7. Document Items Table
CREATE TABLE detalle_item (
    detalle_item_id SERIAL PRIMARY KEY,
    documento_id INTEGER NOT NULL REFERENCES documento(documento_id) ON DELETE CASCADE,
    numero_linea VARCHAR(4) NOT NULL,
    codigo_plu VARCHAR(20),
    bien_o_servicio CHAR(1) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    unidad_medida CHAR(3) NOT NULL,
    precio_unitario DECIMAL(20,2) NOT NULL,
    codigo_impuesto CHAR(1),
    tasa_iva DECIMAL(5,2),
    valor_iva DECIMAL(20,2),
    valor_total_item DECIMAL(20,2),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Retention Details Table
CREATE TABLE detalle_retencion (
    detalle_retencion_id SERIAL PRIMARY KEY,
    documento_id INTEGER NOT NULL REFERENCES documento(documento_id) ON DELETE CASCADE,
    base_imponible DECIMAL(20,2) NOT NULL,
    fecha_documento DATE NOT NULL,
    moneda CHAR(3) NOT NULL,
    monto_iva DECIMAL(20,2),
    monto_islr DECIMAL(20,2),
    porcentaje_iva DECIMAL(5,2),
    porcentaje_islr DECIMAL(5,2),
    retenido_iva DECIMAL(20,2),
    retenido_islr DECIMAL(20,2),
    tipo_documento CHAR(2) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Dispatch Guide Table
CREATE TABLE guia_despacho (
    guia_despacho_id SERIAL PRIMARY KEY,
    documento_id INTEGER NOT NULL REFERENCES documento(documento_id) ON DELETE CASCADE,
    descripcion_servicio VARCHAR(255) NOT NULL,
    destino_producto VARCHAR(255) NOT NULL,
    direccion_origen VARCHAR(255) NOT NULL,
    es_guia_despacho CHAR(1) NOT NULL,
    motivo_traslado VARCHAR(55) NOT NULL,
    origen_producto VARCHAR(55) NOT NULL,
    tipo_producto VARCHAR(55) NOT NULL,
    peso_o_volumen_total DECIMAL(10,2) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Payment Methods Table
CREATE TABLE forma_pago (
    forma_pago_id SERIAL PRIMARY KEY,
    documento_id INTEGER NOT NULL REFERENCES documento(documento_id) ON DELETE CASCADE,
    descripcion VARCHAR(20),
    fecha DATE NOT NULL,
    forma CHAR(2) NOT NULL,
    monto DECIMAL(20,2) NOT NULL,
    moneda CHAR(3) NOT NULL,
    tipo_cambio DECIMAL(12,2),
    igtf DECIMAL(20,2),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Contact Information Table
CREATE TABLE contacto (
    contacto_id SERIAL PRIMARY KEY,
    sujeto_retencion_id INTEGER REFERENCES sujeto_retencion(sujeto_retencion_id) ON DELETE CASCADE,
    comprador_id INTEGER REFERENCES comprador(comprador_id) ON DELETE CASCADE,
    tipo_contacto VARCHAR(10) NOT NULL CHECK (tipo_contacto IN ('telefono', 'correo')),
    valor VARCHAR(50) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_contact_reference CHECK (
        (sujeto_retencion_id IS NOT NULL AND comprador_id IS NULL) OR 
        (sujeto_retencion_id IS NULL AND comprador_id IS NOT NULL)
    )
);

-- 12. Control Table for Document Numbers
CREATE TABLE sequence_child (
    sequence_child_id SERIAL PRIMARY KEY,
    incrementno NUMERIC NOT NULL,
    currentnextsys NUMERIC NOT NULL,
    currentnext NUMERIC NOT NULL,
    startno NUMERIC NOT NULL,
    serie_id VARCHAR(36),
    updated BIGINT NOT NULL DEFAULT (EXTRACT(epoch FROM now()) * 1000),
    org_id INTEGER REFERENCES org(org_id),
    tipo_documento VARCHAR(36) NOT NULL,
    created BIGINT NOT NULL DEFAULT (EXTRACT(epoch FROM now()) * 1000),
    sequence_id VARCHAR(36) NOT NULL,
    createdby VARCHAR(36) NOT NULL,
    isactive BOOLEAN NOT NULL DEFAULT true,
    suffix VARCHAR(20),
    prefix VARCHAR(20),
    isautosequence BOOLEAN NOT NULL DEFAULT true,
    vformat VARCHAR(40),
    description VARCHAR(255),
    name VARCHAR(60) NOT NULL,
    updatedby VARCHAR(36) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT false
);

-- 13. Tax Rates Table
CREATE TABLE tasa_impuesto (
    tasa_impuesto_id SERIAL PRIMARY KEY,
    tipo_impuesto CHAR(1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    tasa DECIMAL(5,2) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Rates Change Log Table
CREATE TABLE log_cambio_tasa (
    log_cambio_tasa_id SERIAL PRIMARY KEY,
    tasa_impuesto_id INTEGER NOT NULL REFERENCES tasa_impuesto(tasa_impuesto_id) ON DELETE CASCADE,
    tasa_anterior DECIMAL(5,2) NOT NULL,
    nueva_tasa DECIMAL(5,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(255),
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Audit Log Table
CREATE TABLE audit_log (
    audit_log_id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES "user"(user_id),
    accion VARCHAR(50) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INTEGER,
    descripcion TEXT,
    org_id INTEGER REFERENCES org(org_id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. System Settings Table
CREATE TABLE configuracion_sistema (
    configuracion_id SERIAL PRIMARY KEY,
    clave VARCHAR(50) NOT NULL UNIQUE,
    valor VARCHAR(255) NOT NULL,
    descripcion TEXT,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 17. Reports Table
CREATE TABLE reporte (
    reporte_id SERIAL PRIMARY KEY,
    nombre_reporte VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo_reporte VARCHAR(50) NOT NULL,
    parametros JSONB,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 18. Partnerships Table
CREATE TABLE tercero (
    tercero_id SERIAL PRIMARY KEY,
    tipo_identificacion CHAR(1) NOT NULL,
    numero_identificacion VARCHAR(20) NOT NULL,
    razon_social VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    org_id INTEGER REFERENCES org(org_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better performance
CREATE INDEX idx_documentos_numero ON documento(numero_documento);
CREATE INDEX idx_documentos_fecha ON documento(fecha_emision);
CREATE INDEX idx_documentos_estado ON documento(estado);
CREATE INDEX idx_items_documento_id ON detalle_item(documento_id);
CREATE INDEX idx_detalles_retencion_id ON detalle_retencion(documento_id);
CREATE INDEX idx_guias_despacho_id ON guia_despacho(documento_id);
CREATE INDEX idx_formas_pago_id ON forma_pago(documento_id);
CREATE INDEX idx_contactos_comprador ON contacto(comprador_id);
CREATE INDEX idx_contactos_sujeto ON contacto(sujeto_retencion_id);
CREATE INDEX idx_vendedores_codigo ON vendedor(codigo);
CREATE INDEX idx_compradores_numero ON comprador(numero_identificacion);
CREATE INDEX idx_sujetos_retencion_numero ON sujeto_retencion(numero_identificacion);
CREATE INDEX idx_tasas_impuestos_tipo ON tasa_impuesto(tipo_impuesto);
CREATE INDEX idx_log_cambios_tasas_fecha ON log_cambio_tasa(fecha_cambio);
CREATE INDEX idx_audit_log_fecha ON audit_log(fecha);
CREATE INDEX idx_audit_log_usuario ON audit_log(usuario_id);

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for automatic updated_at updates
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vendedores_updated_at BEFORE UPDATE ON vendedor FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_compradores_updated_at BEFORE UPDATE ON comprador FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sujetos_retencion_updated_at BEFORE UPDATE ON sujeto_retencion FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_documentos_updated_at BEFORE UPDATE ON documento FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_items_documento_updated_at BEFORE UPDATE ON detalle_item FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_detalles_retencion_updated_at BEFORE UPDATE ON detalle_retencion FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_guias_despacho_updated_at BEFORE UPDATE ON guia_despacho FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_formas_pago_updated_at BEFORE UPDATE ON forma_pago FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contactos_updated_at BEFORE UPDATE ON contacto FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasas_impuesto_updated_at BEFORE UPDATE ON tasa_impuesto FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_configuracion_updated_at BEFORE UPDATE ON configuracion_sistema FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();