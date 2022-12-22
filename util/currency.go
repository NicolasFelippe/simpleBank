package util

const (
	USD = "USD"
	EUR = "EUR"
	CAD = "CAD"
	BRL = "BRL"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, EUR, CAD:
		return true
	}
	return false
}
