import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/models/item.dart';
import 'package:myapp/app/provider/order/order_bloc.dart';
import 'package:myapp/app/provider/order/order_event.dart';
import 'package:myapp/app/provider/orderlist/orderlist_bloc.dart';
import 'package:myapp/app/provider/orderlist/orderlist_event.dart';
import 'package:myapp/app/provider/profile/profile_bloc.dart';
import 'package:myapp/app/provider/profile/profile_event.dart';
import 'package:myapp/app/provider/tamu/tamu_bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_event.dart';
import 'package:myapp/app/provider/undangan/undangan_bloc.dart';
import 'package:myapp/app/provider/undangan/undangan_event.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_bloc.dart';
import 'package:myapp/app/provider/verifyorder/verifyorder_event.dart';
import 'package:myapp/view/fragment/visitordetailitem_screen.dart';
import 'package:myapp/view/visitor/detailutama_screen.dart';
import 'package:myapp/view/visitor/halamanutama_screen.dart';
import 'package:provider/provider.dart';
import 'app/service/api_service.dart';
import 'app/service/auth.dart';
import 'app/provider/auth_bloc.dart';
import 'app/provider/bottom_nav_bloc.dart';
import 'app/provider/management_user_block.dart';
import 'app/provider/item/item_bloc.dart';
import 'app/provider/item/item_event.dart';
import 'view/loginscreen.dart';
import 'view/homescreen.dart';
import 'view/dashboardscreen.dart';
import 'view/dashboardcustomerscreen.dart';
import 'view/registerscreen.dart';
import 'view/management/managementuser_screen.dart';
import 'view/masterdata/item_screen.dart';
import 'package:path_provider/path_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  print('Application Documents Directory: ${directory.path}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        Provider<ApiService>(
          create: (context) => ApiService(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(context.read<AuthProvider>())..add(AutoLoginEvent()),
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider<ManagementUserBlock>(
          create: (context) => ManagementUserBlock(
            context.read<ApiService>(),
            context.read<AuthProvider>(),
          )..add(GetUsers()),
        ),
       BlocProvider<ItemBloc>(
          create: (context) =>
            ItemBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetItems()),
        ),
      BlocProvider<ItemBloc>(
          create: (context) =>
            ItemBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetItemsVisitor()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
            ProfileBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetProfiles()),
        ),
           BlocProvider<OrderBloc>(
          create: (context) =>
            OrderBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetOrders()),
        ),
          BlocProvider<OrderBloc>(
          create: (context) =>
            OrderBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(verifyStatusOrder()),
        ),
          BlocProvider<OrderVerifyBloc>(
          create: (context) =>
            OrderVerifyBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetOrderVerify()),
        ),
           BlocProvider<OrderlistBloc>(
          create: (context) =>
            OrderlistBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetOrderLists()),
        ),
          BlocProvider<UndanganBloc>(
          create: (context) =>
            UndanganBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetUndangans()),
        ),
         BlocProvider<TamuBloc>(
          create: (context) =>
            TamuBloc(context.read<ApiService>(),
            context.read<AuthProvider>(),)..add(GetTamu()),
        ),
        
          
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wedding Check',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => VisitorScreen(),
          '/masuk': (context) => AuthWrapper(),
          '/homescreen': (context) => HomeScreen(),
          '/dashboardscreen': (context) => DashboardScreen(),
          '/dashboardcustomerscreen': (context) => DashboardCustomerScreen(),
          '/loginscreen': (context) => LoginScreen(),
          '/registerscreen': (context) => RegisterScreen(),
          '/managementuserscreen': (context) => ManagementUserScreen(),
          '/itemscreen': (context) => ItemScreen(),
          '/visitoritemdetailscreen': (context) => ItemDetailScreen(item: ModalRoute.of(context)!.settings.arguments as Item),
          '/itemdetailscreen': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return VisitorItemDetailScreen(
              item: args['item'] as Item,
              userId: args['userId'] as int,
            );
          },
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedSuperAdmin) {
          Navigator.of(context).pushReplacementNamed('/homescreen');
        } else if (state is AuthAuthenticatedEmployee) {
          Navigator.of(context).pushReplacementNamed('/dashboardscreen');
        } else if (state is AuthAuthenticatedCustomer) {
          Navigator.of(context).pushReplacementNamed('/dashboardcustomerscreen');
        } else if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed('/loginscreen');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('An error occurred: ${state.message}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()), // Default loading screen
            );
          }
        },
      ),
    );
  }
}