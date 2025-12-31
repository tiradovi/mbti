package com.mbti.mbtitype.model.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MbtiType {
    private Long id;
    private String typeCode;
    private String typeName;
    private String description;
    private String characteristics;
    private String strengths;
    private String weaknesses;
    private String createdAt;
}