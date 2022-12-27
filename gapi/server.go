package gapi

import (
	"fmt"

	"github.com/gin-gonic/gin"
	db "github.com/nicolasfelippe/simplebank/db/sqlc"
	"github.com/nicolasfelippe/simplebank/pb"
	"github.com/nicolasfelippe/simplebank/token"
	"github.com/nicolasfelippe/simplebank/util"
)

type Server struct {
	pb.UnimplementedSimpleBankServer 
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
	router     *gin.Engine
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := setupMaker(config)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		tokenMaker: tokenMaker,
		store:      store,
	}

	return server, nil
}

func setupMaker(config util.Config) (token.Maker, error) {
	if config.AuthType == util.JWT {
		return token.NewJWTMaker(config.TokenSymmectricKey)
	}
	return token.NewPasetoMaker(config.TokenSymmectricKey)
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
