module Types
  class QueryType < Types::BaseObject
    # Obtener una persona por cédula
    field :persona, PersonaType, null: true do
      argument :cedula, String, required: true
    end

    def persona(cedula:)
      Persona.find_by(cedula: cedula)
    end

    # Obtener todas las amistades donde persona 1 es la cédula dada
    field :amistades, [AmistadType], null: false do
      argument :cedula_persona1, String, required: true
    end

    def amistades(cedula_persona1:)
      Amistad.where(cedula_persona1: cedula_persona1)
    end
  end
end
