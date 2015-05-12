//
//  Red.h
//  PruebaRedes
//
//  Created by Roberto Martínez on 06/07/13.


#import <Foundation/Foundation.h>

@protocol RedDelegado
-(void) terminaDescarga:(NSData*)datos conID:(NSInteger)ID;
-(void) errorEnDescarga:(NSInteger)codigo conID:(NSInteger)ID;
@end

@interface Red : NSObject <NSURLConnectionDataDelegate>

// Delegado, es el objeto que solicita la descarga de datos
@property (nonatomic,strong) NSObject<RedDelegado> *delegado;
// Buffer de datos
@property (nonatomic,strong) NSMutableData *datosDescargados;
// Para hacer la descarga
@property (nonatomic,strong) NSURLConnection *conexion;
// El ID de la tarea de descarga
@property (nonatomic) NSInteger ID;
// El método que utilizan los usuarios de esta clase
-(void) descargar:(NSString*)direccion conID:(NSInteger)ID;

@end