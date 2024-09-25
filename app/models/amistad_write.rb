class AmistadWrite
  attr_accessor :cedula_persona1, :cedula_persona2

  def initialize(cedula_persona1, cedula_persona2)
    @cedula_persona1 = cedula_persona1
    @cedula_persona2 = cedula_persona2
  end

  # Método para guardar la amistad en Cassandra
  def save
    $cassandra_session.execute(
      "INSERT INTO amistad_write (cedula_persona1, cedula_persona2) VALUES (?, ?)",
      arguments: [@cedula_persona1, @cedula_persona2]
    )
  end

  # Método para buscar una amistad por las dos cédulas
  def self.find_by_cedulas(cedula_persona1, cedula_persona2)
    result = $cassandra_session.execute(
      "SELECT * FROM amistad_write WHERE cedula_persona1 = ? AND cedula_persona2 = ? LIMIT 1",
      arguments: [cedula_persona1, cedula_persona2]
    )
    result.first ? new(result.first['cedula_persona1'], result.first['cedula_persona2']) : nil
  end

  # Método para eliminar una amistad por las dos cédulas
  def self.delete_by_cedulas(cedula_persona1, cedula_persona2)
    $cassandra_session.execute(
      "DELETE FROM amistad_write WHERE cedula_persona1 = ? AND cedula_persona2 = ?",
      arguments: [cedula_persona1, cedula_persona2]
    )
  end
end
