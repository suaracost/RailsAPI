class Amistad
    attr_accessor :cedula_persona1, :cedula_persona2
  
    def initialize(cedula_persona1, cedula_persona2)
      @cedula_persona1 = cedula_persona1
      @cedula_persona2 = cedula_persona2
    end
  
    # Método para insertar una amistad en Cassandra
    def save
      $cassandra_session.execute(
        "INSERT INTO amistad (cedula_persona1, cedula_persona2) VALUES (?, ?)",
        arguments: [@cedula_persona1, @cedula_persona2]
      )
    end
  
    # Método para obtener todas las amistades
    def self.all
      rows = $cassandra_session.execute("SELECT * FROM amistad")
      rows.map { |row| new(row['cedula_persona1'], row['cedula_persona2']) }
    end

      # Método para eliminar una amistad por las dos cédulas en la tabla de lectura
    def self.delete_by_cedulas(cedula_persona1, cedula_persona2)
      $cassandra_session.execute(
        "DELETE FROM amistad WHERE cedula_persona1 = ? AND cedula_persona2 = ?",
        arguments: [cedula_persona1, cedula_persona2]
      )
    end
  end
  