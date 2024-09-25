class PersonaWrite
  attr_accessor :cedula, :nombre

  def initialize(cedula, nombre)
    @cedula = cedula
    @nombre = nombre
  end

  # Método para insertar o actualizar un registro en Cassandra
  def save
    $cassandra_session.execute(
      "INSERT INTO persona_write (cedula, nombre) VALUES (?, ?)",
      arguments: [@cedula, @nombre]
    )
  end

  # Método para eliminar una persona por cédula (debe ser de clase)
  def self.delete_by_cedula(cedula)
    $cassandra_session.execute(
      "DELETE FROM persona_write WHERE cedula = ?",
      arguments: [cedula]
    )
  end

  # Método para buscar una persona por cédula (debe ser de clase)
  def self.find_by_cedula(cedula)
    result = $cassandra_session.execute(
      "SELECT * FROM persona_write WHERE cedula = ? LIMIT 1",
      arguments: [cedula]
    )
    result.first ? new(result.first['cedula'], result.first['nombre']) : nil
  end
end
