# # C:\Users\DELL\Desktop\ProfsChezVous\ProfsChezVous_Backend\user\firebase_setup.py

# import firebase_admin
# from firebase_admin import credentials, auth

# # Remplacez ce chemin par le chemin réel vers votre fichier de clé de compte de service
# cred = credentials.Certificate('C:/Users/DELL/Desktop/ProfsChezVous/ProfsChezVous_Backend/user/serviceAccountKey.json')
# firebase_admin.initialize_app(cred)

# def envoyer_otp(numero_tel):
#     verification = auth.send_verification_code(
#         phone_number=numero_tel,
#         recaptcha_token=auth.generate_recaptcha_token()
#     )
#     return verification.session_info

# def verifier_otp(session_info, otp_code):
#     try:
#         phone_auth_credential = auth.PhoneAuthProvider.verify_code(
#             session_info=session_info,
#             code=otp_code
#         )
#         return True
#     except Exception as e:
#         print(e)
#         return False
