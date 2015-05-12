//
//  Red.m
//  PruebaRedes
//
//  Created by Roberto Martínez on 06/07/13.


#import "Red.h"

@implementation Red

-(void) descargar:(NSString *)direccion conID:(NSInteger)ID
{
    self.ID = ID;
    NSURL *url = [NSURL URLWithString:direccion];
    
    NSURLRequest *peticion = [NSURLRequest requestWithURL:url];
    // Arranca la descarga ASINCRONA
    self.conexion = [[NSURLConnection alloc] initWithRequest:peticion delegate:self];
    
    if (self.conexion!=nil) { // Se creó correctamente
        // Crea el buffer
        self.datosDescargados = [NSMutableData data];
    }
}

// Métodos del DELEGADO de NSURLConnection (conexion)
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.datosDescargados.length = 0;
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.datosDescargados appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Entrega los datos a quien solicitó la descarga
    [self.delegado terminaDescarga:self.datosDescargados conID:self.ID];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegado errorEnDescarga:error.code conID:self.ID];
}

@end