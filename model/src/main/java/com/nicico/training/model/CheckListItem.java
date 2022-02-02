package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_check_list_item")
public class CheckListItem extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "check_list_item_seq")
    @SequenceGenerator(name = "check_list_item_seq", sequenceName = "seq_check_list_item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_group")
    private String group;

    @Column(name = "b_is_deleted")
    private Boolean isDeleted;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_check_list_id", insertable = false, updatable = false)
    private CheckList checkList;

    @Column(name = "f_check_list_id")
    private Long checkListId;
}
