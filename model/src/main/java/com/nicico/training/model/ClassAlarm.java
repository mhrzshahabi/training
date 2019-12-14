package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.EntityResult;
import javax.persistence.FieldResult;
import javax.persistence.SqlResultSetMapping;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
public class ClassAlarm {

    private Long targetRecordId;

    private String tabName;

    private String pageAddress;

    private String alarmType;

    private String alarm;
}
