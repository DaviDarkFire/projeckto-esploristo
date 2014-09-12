require 'rubygems'
require 'sinatra'
require 'active_support'
require 'mongo_mapper'
require 'bcrypt'

MongoMapper.database = "feirando"

class Evento
	include MongoMapper::Document
	key :nomeEvento, String, :required => true
	key :siglaEvento, String, :required => true
	key :dataEvento, String, :required => true
	key :localEvento, String, :required => true
	key :cidadeEvento, String, :required => true
	key :estadoEvento, String, :required => true
	key :tipoEvento, String, :required => true
	key :areaEvento, String, :required => true
	key :nivelEvento, String, :required => true
	key :siteEvento, String, :required => true
	key :textoEvento, String, :required => true
	key :telefoneEvento, String, :required => true
	key :emailEvento, String, :required => true
	key :imagemEvento, String
	timestamps!
end

class Duvida
	include MongoMapper::Document
	key :pergunta, String, :required => true
	key :resposta, String, :required => true
	key :link, String
end


class Usuario		
	include MongoMapper::Document
	include BCrypt
	key :nome, String, :required => true	
	key :senha, String, :required => true	
	key :email, String, :required => true	
	key :instituicao, String
	key :salt, String
	timestamps!
end

class Administrador
	include MongoMapper::Document
	include BCrypt
	key :nome, String, :required => true	
	key :senha, String, :required => true	
	key :emailAdmin, String, :required => true	
	key :salt, String
	timestamps!

end

get '/' do
	@feiras = Evento.all(:order => :id.desc)
	erb :home
end


get '/novoEvento' do
	erb :cadastrarEvento
end

post '/novoEvento' do
	e = Evento.new(:nomeEvento => params[:nomeEvento], :siglaEvento => params[:siglaEvento], :dataEvento => params[:dataEvento], :localEvento => params[:localEvento], :cidadeEvento => params[:cidadeEvento], :estadoEvento => params[:estadoEvento], :tipoEvento => params[:tipoEvento], :areaEvento => params[:areaEvento], :nivelEvento => params[:nivelEvento], :siteEvento => params[:siteEvento], :textoEvento => params[:textoEvento], :emailEvento => params[:emailEvento], :telefoneEvento => params[:telefoneEvento], :imagemEvento => params[:imagemEvento])
	e.save
	redirect '/'
end


get '/all' do
	@tudo = Evento.all(:order => :id)
	@todo = Administrador.all(:order => :id)
	erb :all
end 


get '/novoAdmin' do
	erb :cadastrarAdmin
end

post '/novoAdmin' do
	password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:senhaAdmin], password_salt)

	a = Administrador.new(:nome => params[:nomeAdmin], :emailAdmin => params[:emailAdmin], :salt => password_salt, :senha => password_hash)
	a.save
	redirect '/all'
end

get '/novaDuvida' do
	erb :cadastrarDuvida
end

post '/novaDuvida' do
	d = Duvida.new(:pergunta => params[:pergunta], :resposta => params[:resposta], :link => params[:link])
	d.save
	redirect '/all'
end

 enable :sessions 
 
helpers do
  
  def login?
    if session[:emailAdmin].nil?
      return false
    else
      return true
    end
  end


  def username
    return session[:emailAdmin]
  end
  
  
end 


get '/login' do
	erb :login
end

post "/login" do
	@user
  if Administrador.find_by_emailAdmin(params[:emailAdmin])
    @adm = Administrador.find_by_emailAdmin(params[:emailAdmin])    
    if @adm[:senha] == BCrypt::Engine.hash_secret(params[:senha], @adm[:salt])      
      session[:emailAdmin] = params[:emailAdmin]      

      redirect "/admin"
    end
  end
  erb :loginError
end

get '/admin' do
	redirect '/all'
end

before '/novoAdmin' do
 	if !login?
 		redirect '/login'
 	else
 		erb :cadastrar
 	end
end

before '/novoAdmin' do
 	if !login?
 		redirect '/login'
 	else
 		erb :cadastrar
 	end
end

# get '/' do
# 	erb :home
# end

# get '/vocenaodeveriaestaraqui' do	
# 	Evento.destroy_all	
# 	redirect '/'
# end

# get '/resultado/:id' do	
#   	@resultados = Palavra.where(:id => params[:id]);
# 	erb :resultado
# end

# before '/cadastrar' do
# 	if !login?
# 		redirect '/login'
# 	else
# 		erb :cadastrar
# 	end
# end

# get '/cadastrar' do
# 	erb :cadastrar
# end

# post '/cadastrar' do		

# 	us = session[:email]
	
# 	p = Palavra.new(:nome => params[:nome], :regiao => params[:regiao], :lingua => params[:lingua], :descricao => params[:descricao], :aprovada => 0, :user => us ) 	
# 	File.open('public/ani' + p.id, "w") do |f|
#     	f.write(params['animacao'][:tempfile].read)    	
#   	end

#   	File.open('public/img' + p.id, "w") do |f|
#     	f.write(params['image'][:tempfile].read)    	
#   	end  	
#   	p[:animacao] = 'ani' + p.id
#   	p[:image] =  'img' + p.id
# 	p.save	  		

# 	redirect '/'
	
# end

# get '/mostrar' do	
# 	erb :amostra
# end

# get '/usu' do
# 	@adm = Administrador.all(:order => :id)
# 	@usu = Usuario.all(:order => :id)
# 	erb :usu
# end

# post '/buscar' do
#   palavra = params[:palavra]  
#   @palavras = Palavra.all(:nome => palavra, :aprovada => 1, :order => :regiao.asc)
#   erb :amostrar
# end

# get '/signup' do
# 	erb :signup
# end

# enable :sessions 
 
# helpers do
  
#   def login?
#     if session[:email].nil?
#       return false
#     else
#       return true
#     end
#   end


#   def username
#     return session[:email]
#   end

#   def adminLog?
#     if session[:emailAdmin].nil?
#       return false
#     else
#       return true
#     end
#   end

#   def admName?
#   	return session[:emailAdmin]
#   end
  
# end 
 
# before '/deletePalavra/:id' do
# 	if session[:email].nil?
# 		redirect '/login'	
# 	end
# end

# get '/deletePalavra/:id' do
# 	var = Palavra.find(params[:id])
# 	var.destroy
# 	redirect '/'
# end

# before '/editPalavra/:id' do
# 	if session[:email].nil?
# 		redirect '/login'	
# 	end
# end

# get '/editPalavra/:id' do
# 	@editPalavra = Palavra.find(params[:id])
# 	erb :editPalavra
# end

# put '/editPalavra/:id' do
# 	p = Palavra.find(params[:id])
# 	p.nome = params[:nome]
# 	p.regiao = params[:regiao]
# 	p.lingua = params[:lingua]
# 	aniPath = params[:nome]+ 'ani'
# 	imgPath = params[:nome]+ 'img'
# 	p.animacao = aniPath
# 	p.image = imgPath
# 	p.aprovada = 0
# 	p.save
# 	File.open('./public/' + params[:nome] + 'ani', "w") do |f|
#     	f.write(params['animacao'][:tempfile].read)    	
#   	end

#   	File.open('./public/' + params[:nome] + 'img', "w") do |f|
#     	f.write(params['image'][:tempfile].read)    	
#   	end 
#   	redirect '/account'
# end

# post "/signup" do  
#   password_salt = BCrypt::Engine.generate_salt
#   password_hash = BCrypt::Engine.hash_secret(params[:senhaUs], password_salt)

#   u = Usuario.new(:nome => params[:nomeUs], :email => params[:emailUs], :senha => password_hash, :regiao => params[:regiaoUs], :pais => params[:paisUs], :salt => password_salt)		
#   u.save  
#   session[:email] = params[:emailUs]
  
#   redirect "/"
# end
 
# post "/login" do
# 	@user
#   if Usuario.find_by_email(params[:email])
#     @user = Usuario.find_by_email(params[:email])    
#     if @user[:senha] == BCrypt::Engine.hash_secret(params[:password], @user[:salt])      
#       session[:email] = params[:email]      

#       redirect "/account"
#     end
#   end
#   erb :loginError
# end

# before '/editUser/:email' do
# 	if session[:email].nil?
# 		redirect '/login'
# 	else
# 		if session[:email] != params[:email]							
# 			redirect '/login'
# 		end		
# 	end

# end

# get '/editUser/:email' do	
# 	@editUser = Usuario.find_by_email(params[:email])
# 	erb :editUser	
# end

# put '/editUser/:email' do
# 	u = Usuario.find_by_email(params[:email])
# 	u.nome = params[:nomeUs]
# 	u.regiao = params[:regiaoUs]
# 	u.pais = params[:paisUs]
# 	u.save
# 	redirect '/account'
# end


 
# get "/logout" do
#   session[:email] = nil
#   session[:emailAdmin] = nil
#   redirect "/"
# end

# before '/account' do
# 	if session[:email].nil?
# 		redirect '/login'	
# 	end
# end

# get '/account' do
# 	@user = Usuario.find_by_email(session[:email])
# 	@envios = Palavra.all(:user => @user.email)
# 	erb :account
# end

# get '/adminLog' do
# 	erb :admLog
# end

# post '/adminLog' do
# 	@admin
#   if Administrador.find_by_emailAdmin(params[:emailAdmin])
#     @admin = Administrador.find_by_emailAdmin(params[:emailAdmin])    
#     if @admin[:senha] == BCrypt::Engine.hash_secret(params[:password], @admin[:salt])      
#       session[:emailAdmin] = params[:emailAdmin]      

#       redirect "/admin"
#     else
#     	redirect '/'
#     end
#   end
# end


# before '/admin' do
# 	if session[:emailAdmin].nil?
# 		redirect '/adminLog'	
# 	end
# end

# get '/admin' do
# 	@type = "Pendentes"
# 	@listaPalavras = Palavra.all(:aprovada => 0, :order => :nome.asc)
# 	erb :admin

# end

# get '/cadastroAdmin' do
# 	erb :addAdmin
# end

# post '/cadastroAdmin' do
# 	password_salt = BCrypt::Engine.generate_salt
#   	password_hash = BCrypt::Engine.hash_secret(params[:senhaAd], password_salt)
# 	a = Administrador.new(:nome => params[:nomeAd], :senha => password_hash, :regiao => params[:regiaoAd], :pais => params[:paisAd], :emailAdmin => params[:emailAd], :salt => password_salt)
# 	a.save;
# 	session[:emailAdmin] = params[:emailAd];
# 	redirect '/admin'
# end

# before '/admin/:type' do
# 	if session[:emailAdmin].nil?
# 		redirect '/adminLog'	
# 	end
# end

# get '/admin/:type' do
# 	if params[:type] == "pendentes"
# 		@type = "Pendentes"
# 		@listaPalavras = Palavra.all(:aprovada => 0, :order => :nome.asc)
# 	elsif  params[:type] == "aprovadas"
# 		@type = "Aprovadas"
# 		@listaPalavras = Palavra.all(:aprovada => 1, :order => :nome.asc)
# 	elsif  params[:type] == "recusadas"
# 		@type = "Recusadas"
# 		@listaPalavras = Palavra.all(:aprovada => 2, :order => :nome.asc)
# 	else
# 		redirect '/admin'	
# 	end
# 	erb :admin
		
# end

# before '/resultado/:id/aprovacao' do
# 	if session[:emailAdmin].nil?
# 		redirect '/adminLog'	
# 	end
# end

# get '/resultado/:id/aprovacao' do
# 	erb :aprovacao
# end

# put '/resultado/:id/aprovacao' do
# 	p = Palavra.find(params[:id])
# 	p.aprovada = params[:aprovada]
# 	p.save
# 	redirect '/admin'
# end

