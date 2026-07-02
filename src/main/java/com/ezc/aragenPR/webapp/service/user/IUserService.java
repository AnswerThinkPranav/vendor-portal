package com.ezc.aragenPR.webapp.service.user;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.dto.user.UserDto;
import com.ezc.aragenPR.webapp.error.UserAlreadyExistException;
import com.ezc.aragenPR.webapp.model.user.PasswordResetToken;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.user.VerificationToken;
import com.ezc.aragenPR.webapp.model.user.WorkGroup_Users;
import com.ezc.aragenPR.webapp.model.user.Work_Groups;

public interface IUserService {

	Users registerNewUserAccount(UserDto accountDto) throws UserAlreadyExistException;

	Users getUser(String verificationToken);

	void editUser(UserDto accountDto);

	void deleteUser(Users user);

	void createVerificationTokenForUser(Users user, String token);

	VerificationToken getVerificationToken(String VerificationToken);

	VerificationToken generateNewVerificationToken(String token);

	void createPasswordResetTokenForUser(Users user, String token);

	Users findUserByEmail(String email);
	
	Users findUserByUserId(String userId);
	
	Users findUserByUserIdOrEmail(String userId,String email);
	

	PasswordResetToken getPasswordResetToken(String token);

	Users getUserByPasswordResetToken(String token);

	Optional<Users> getUserByID(long id);

	void changeUserPassword(Users user, String password);

	void changePasswordByEmail(String email, String newPassword);

	boolean checkIfValidOldPassword(Users user, String password);

	String validateVerificationToken(String token);

	String generateQRUrl(Users user) throws UnsupportedEncodingException;

	Users updateUser2FA(boolean use2FA);

	List<String> getUsersFromSessionRegistry();
	
	List<Users> getUsersList();
	
	List<WorkGroup_Users> getGroupsByUserId(String userId);
	
	List<Work_Groups> getAllGroups();
	
	List<Work_Groups> getGroupsByRole(String role);
	
	//List<WorkGroup_Users> getStateHeadSubGroups(String stateHeadGrp);
	
	List<WorkGroup_Users> getZonalHeadSubGroups(String zonalHeadGrp);

	List<WorkGroup_Users> getStateHeadSubGroups(String stateHDGrp);
	
	List<Users> findUsersByRole(String role);

	HashMap<String,String> getUsersName();
	
}
