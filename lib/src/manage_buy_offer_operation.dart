// Copyright 2020 The Stellar Flutter SDK Authors. All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE file.

import 'operation.dart';
import 'assets.dart';
import 'util.dart';
import 'xdr/xdr_operation.dart';
import 'xdr/xdr_type.dart';
import 'xdr/xdr_offer.dart';
import 'price.dart';
import 'muxed_account.dart';

/// Represents <a href="https://developers.stellar.org/docs/start/list-of-operations/#manage-buy-offer" target="_blank">ManageBuyOffer</a> operation.
/// See: <a href="https://developers.stellar.org/docs/start/list-of-operations/" target="_blank">List of Operations</a>
class ManageBuyOfferOperation extends Operation {
  Asset _selling;
  Asset _buying;
  String _amount;
  String _price;
  String _offerId;

  /// Creates, updates, or deletes an offer to buy one asset for another, otherwise known as a "bid" order on a traditional orderbook:
  /// [selling] is the asset the offer creator is selling.
  /// [buying] is the asset the offer creator is buying.
  /// [amount] is the amount of buying being bought. Set to 0 if you want to delete an existing offer.
  /// [price] is the price of 1 unit of buying in terms of selling. (e.g. "0.1" => pay up to 0.1 asset selling for 1 unit asset of buying).
  /// [offerId] set to "0" for a new offer, otherwise the id of the offer to be changed or removed.
  ManageBuyOfferOperation(
      this._selling, this._buying, this._amount, this._price, this._offerId);

  /// The asset being sold in this operation
  Asset get selling => _selling;

  /// The asset being bought in this operation
  Asset get buying => _buying;

  /// Amount of selling being sold.
  String get amount => _amount;

  /// Price of 1 unit of selling in terms of buying.
  String get price => _price;

  /// The ID of the offer.
  String get offerId => _offerId;

  @override
  XdrOperationBody toOperationBody() {
    XdrBigInt64 amount =
        new XdrBigInt64(Util.toXdrBigInt64Amount(this.amount));
    Price price = Price.fromString(this.price);
    XdrUint64 offerId = new XdrUint64(int.parse(this.offerId));
    XdrManageBuyOfferOp op = new XdrManageBuyOfferOp(
        selling.toXdr(), buying.toXdr(), amount, price.toXdr(), offerId);

    XdrOperationBody body =
        new XdrOperationBody(XdrOperationType.MANAGE_BUY_OFFER);
    body.manageBuyOfferOp = op;

    return body;
  }

  /// Construct a new CreateAccount builder from a CreateAccountOp XDR.
  static ManageBuyOfferOperationBuilder builder(XdrManageBuyOfferOp op) {
    int n = op.price.n.int32.toInt();
    int d = op.price.d.int32.toInt();

    return ManageBuyOfferOperationBuilder(
      Asset.fromXdr(op.selling),
      Asset.fromXdr(op.buying),
      Util.fromXdrBigInt64Amount(op.amount.bigInt),
      removeTailZero((BigInt.from(n) / BigInt.from(d)).toString()),
    ).setOfferId(op.offerID.uint64.toInt().toString());
  }
}

class ManageBuyOfferOperationBuilder {
  Asset _selling;
  Asset _buying;
  String _amount;
  String _price;
  String _offerId = "0";
  MuxedAccount? _mSourceAccount;

  /// Creates a new ManageSellOffer builder. If you want to update existing offer use [ManageBuyOfferOperationBuilder.setOfferId].
  /// The operation creates, updates, or deletes an offer to buy one asset for another, otherwise known as a "bid" order on a traditional orderbook:
  /// [_selling] is the asset the offer creator is selling.
  /// [_buying] is the asset the offer creator is buying.
  /// [_amount] is the amount of buying being bought. Set to 0 if you want to delete an existing offer.
  /// [_price] is the price of 1 unit of buying in terms of selling. (e.g. "0.1" => pay up to 0.1 asset selling for 1 unit asset of buying).
  ManageBuyOfferOperationBuilder(
      this._selling, this._buying, this._amount, this._price);

  /// Sets offer ID. <code>0</code> creates a new offer. Set to existing offer ID to change it.
  ManageBuyOfferOperationBuilder setOfferId(String offerId) {
    this._offerId = offerId;
    return this;
  }

  /// Sets the source account for this operation.
  ManageBuyOfferOperationBuilder setSourceAccount(String sourceAccountId) {
    MuxedAccount? sa = MuxedAccount.fromAccountId(sourceAccountId);
    _mSourceAccount = checkNotNull(sa, "invalid sourceAccountId");
    return this;
  }

  /// Sets the muxed source account for this operation.
  ManageBuyOfferOperationBuilder setMuxedSourceAccount(
      MuxedAccount sourceAccount) {
    _mSourceAccount = sourceAccount;
    return this;
  }

  /// Builds a ManageBuyOfferOperation.
  ManageBuyOfferOperation build() {
    ManageBuyOfferOperation operation = new ManageBuyOfferOperation(
        _selling, _buying, _amount, _price, _offerId);
    if (_mSourceAccount != null) {
      operation.sourceAccount = _mSourceAccount;
    }
    return operation;
  }
}
