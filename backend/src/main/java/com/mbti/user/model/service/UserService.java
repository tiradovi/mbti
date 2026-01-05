package com.mbti.user.model.service;

import com.mbti.user.model.dto.User;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface UserService {
    User login(String userName) throws Exception;

    User signup(String userName);

    User getUserById(int id);

    User getUserByUserName(String userName);

    List<User> getAllUsers();

    void deleteUser(int id);
}
