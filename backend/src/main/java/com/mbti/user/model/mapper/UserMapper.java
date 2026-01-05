package com.mbti.user.model.mapper;

import com.mbti.user.model.dto.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {
    List<User> selectAll();
    User selectById(int id);
    User selectByUserName(String userName);
    void insert(User user);
    int insertUser(User user);
    void updateLastLogin(int id);
    void delete(int id);
}
