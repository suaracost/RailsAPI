class Persona
  attr_accessor :cedula, :nombre

  def initialize(cedula, nombre)
    @cedula = cedula
    @nombre = nombre
  end

  # Método para insertar un nuevo registro en Cassandra
  def save
    $cassandra_session.execute(
      "INSERT INTO persona (cedula, nombre) VALUES (?, ?)",
      arguments: [@cedula, @nombre]
    )
  end

  # Método para actualizar el nombre de una persona en Cassandra
  def update(nombre)
    @nombre = nombre
    $cassandra_session.execute(
      "UPDATE persona SET nombre = ? WHERE cedula = ?",
      arguments: [@nombre, @cedula]
    )
  end

  # Método para obtener todas las personas de Cassandra
  def self.all
    rows = $cassandra_session.execute("SELECT * FROM persona")
    rows.map { |row| new(row['cedula'], row['nombre']) }
  end

  # Método para buscar una persona por cédula
  def self.find_by_cedula(cedula)
    result = $cassandra_session.execute(
      "SELECT * FROM persona WHERE cedula = ? LIMIT 1",
      arguments: [cedula]
    )
    result.first ? new(result.first['cedula'], result.first['nombre']) : nil
  end

  # Método para eliminar una persona por cédula
  def self.delete_by_cedula(cedula)
    $cassandra_session.execute(
      "DELETE FROM persona WHERE cedula = ?",
      arguments: [cedula]
    )
  end
end
