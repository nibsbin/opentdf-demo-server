package kasgateway

import (
	"context"
	"log/slog"

	"connectrpc.com/connect"
	kaspb "github.com/opentdf/platform/protocol/go/kas"
	"github.com/opentdf/platform/protocol/go/kas/kasconnect"
	"github.com/opentdf/platform/service/kas"
	"github.com/opentdf/platform/service/pkg/serviceregistry"
)

type KasGatewayService struct {
	kasconnect.UnimplementedAccessServiceHandler

	internalKas kasconnect.AccessServiceHandler
}

func (s *KasGatewayService) PublicKey(ctx context.Context, r *connect.Request[kaspb.PublicKeyRequest]) (*connect.Response[kaspb.PublicKeyResponse], error) {
	return s.internalKas.PublicKey(ctx, r)
}

func (s *KasGatewayService) Rewrap(ctx context.Context, r *connect.Request[kaspb.RewrapRequest]) (*connect.Response[kaspb.RewrapResponse], error) {
	return s.internalKas.Rewrap(ctx, r)
}

func NewRegistration() *serviceregistry.Service[kasconnect.AccessServiceHandler] {
	kasReg := kas.NewRegistration()
	kasRegFunc := kasReg.RegisterFunc

	kasReg.RegisterFunc = func(srp serviceregistry.RegistrationParams) (kasconnect.AccessServiceHandler, serviceregistry.HandlerServer) {
		kasSvc, err := kasRegFunc(srp)
		if err != nil {
			panic(err)
		}

		gatewaySvc := &KasGatewayService{
			internalKas: kasSvc,
		}

		slog.Info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> KAS GATEWAY initialized")

		return gatewaySvc, nil
	}

	return kasReg
}
