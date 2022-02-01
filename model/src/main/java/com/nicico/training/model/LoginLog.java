package com.nicico.training.model;

import com.nicico.training.model.enums.LoginState;
import lombok.*;

import javax.persistence.*;
import java.sql.Timestamp;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tbl_login_log")
public class LoginLog {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "login_log_seq")
    @SequenceGenerator(name = "login_log_seq", sequenceName = "seq_login_log_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "USER_NAME")
    private String username;

    @Column(name = "FIRST_NAME")
    private String firstName;

    @Column(name = "LAST_NAME")
    private String lastName;

    @Column(name = "NATIONAL_CODE")
    private String nationalCode;

    @Column(name = "CREATE_DATE")
    private Timestamp createDate;

    @Column(name = "LOGIN_STATE")
    @Enumerated(EnumType.STRING)
    private LoginState state;

    @Column(name = "HASH_TOKEN")
    private String hashToken;

    @PrePersist
    public void setDate() {
        this.createDate = new Timestamp(System.currentTimeMillis());
    }
}
