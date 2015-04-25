keyBuffer = new ReactiveVar([])
detected  = new ReactiveVar("")

Meteor.startup ->
  timeOut = false
  $(document).on("keydown", (event) ->
    if timeOut
      Meteor.clearTimeout(timeOut)
      timeOut = false
      
    buffer  = keyBuffer.get()
    keyCode = event.keyCode
    key     = if (96 <= keyCode <= 105) then keyCode-48 else keyCode
    if key is 13 and buffer.length
      detected.set(keyBuffer.get().join(""))
      keyBuffer.set([])
    else
      buffer.push(String.fromCharCode(key))
      keyBuffer.set(buffer)
    Meteor.setTimeout(->
        keyBuffer.set([])
    ,100)
  )
  
  

Template.detectKeys.helpers
  detected: ->
    detected.get()
  producto: ->
    Productos.findOne({codigo: detected.get()})

Template.newProducto.events
  "submit form": (event, template)->
    event.preventDefault()
    producto = {}
    producto.nombre      = template.find("#nombre").value
    producto.url_imagen  = template.find("#url_imagen").value
    producto.valor       = template.find("#valor").value
    producto.descripcion = template.find("#descripcion").value
    producto.codigo      = detected.get()
    
    Productos.insert(producto)
  
  